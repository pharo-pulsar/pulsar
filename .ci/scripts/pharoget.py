#!/usr/bin/env python3

import argparse
import os
import shutil
import subprocess
import sys
import tempfile
import zipfile
import re
import io
import urllib.request
from urllib.parse import urljoin
from urllib.request import urlopen
from urllib.request import urlretrieve

SUPPORTED_VERSIONS = [
    "1.4", "2.0", "3.0", "4.0", "5.0", "6.0", "7.0", "8.0",
    "9.0", "10.0", "11.0", "12.0", "13.0", "14.0"
]
DEFAULT_VERSION = "14.0"
DEFAULT_DIR_PREFIX = "pharo"
DOWNLOAD_DEST_DIR = "/tmp/pharo-images"

def run(cmd):
    """Run shell command safely."""
    print(f"+ {' '.join(cmd)}")
    subprocess.run(cmd, check=True)

def find_snapshot_url(base_url, prefix):
    """
    Look inside `base_url` (an HTTP directory listing) for the first file
    whose name starts with `prefix`, and return the full URL.

    Example:
        find_snapshot_url(
            "https://files.pharo.org/image/140/",
            "Pharo14.0-SNAPSHOT.build.260"
        )
        → "https://files.pharo.org/image/140/Pharo14.0-SNAPSHOT.build.260.sha.eb77577510.arch.64bit.zip"
    """
    with urlopen(base_url) as response:
        html = response.read().decode("utf-8")

    files = re.findall(r'href="([^"]+)"', html)
    matches = [f for f in files if f.startswith(prefix)]

    if not matches:
        return None

    # Optionally pick the last one alphabetically (often the latest build)
    matches.sort()
    return urljoin(base_url, matches[-1])

def download_with_progress(url, dest):
    """Download a file with a visible progress bar (like curl)."""
    with urllib.request.urlopen(url) as response, open(dest, 'wb') as out_file:
        total = response.length
        downloaded = 0
        block_size = 8192

        print(f"Downloading {url}")
        while True:
            chunk = response.read(block_size)
            if not chunk:
                break
            out_file.write(chunk)
            downloaded += len(chunk)
            if total:
                percent = downloaded * 100 / total
                bar = f"[{'=' * int(percent // 2):50s}]"
                sys.stdout.write(f"\r{bar} {percent:5.1f}%")
                sys.stdout.flush()
        sys.stdout.write("\n✅ Done.\n")

def download_without_progress(url, dest):
    """Download a file without showing progress."""
    with urllib.request.urlopen(url) as response, open(dest, "wb") as out_file:
        print(f"Downloading {url}")
        while True:
            chunk = response.read(8192)
            if not chunk:
                break
            out_file.write(chunk)
        
        print("✅ Done.")

def prepare_image(version=DEFAULT_VERSION, build=None, dest_dir=DEFAULT_DIR_PREFIX, image_name=None, kill=False):
    """
    Prepare a Pharo image with the given version, build, and destination directory.

    - `version`: Pharo version number, e.g. "14.0".
    - `build`: Pharo build number, e.g. "260".
    - `dest_dir`: Destination directory for the prepared image.
    - `image_name`: custom name for the prepared image.
    - `kill`: if `True`, kill the existing directory with the same name as `dest_dir`.

    This function first downloads the Pharo image from the official Pharo repository,
    and then extracts the image into the destination directory.

    If `kill` is `True`, the existing directory with the same name as `dest_dir`
    will be deleted.

    If the image name ends with ".image" or ".changes", it will be renamed to the
    custom image name.

    Finally, if a file named `<image_name>.st` or `config.st` exists in the
    destination directory, it will be executed with `phconfig`.

    :return: None
    """
    flat_version = version.replace(".", "")
    arch = subprocess.check_output(["uname", "-m"]).decode("utf-8").strip()
    arch_suffix = "64" if arch == "x86_64" else ""

    os.makedirs(DOWNLOAD_DEST_DIR, exist_ok=True)

    keep_file_name = os.path.join(
        DOWNLOAD_DEST_DIR, f"Pharo-{version}-{arch}-last.zip"
    )
    if os.path.exists(keep_file_name):
        os.remove(keep_file_name)

    # Decide download URL
    if int(flat_version) >= 100:
        if not build:
            download_url = (
                f"http://files.pharo.org/get-files/{flat_version}/pharoImage-x86_64.zip"
            )
        else:
            download_url = find_snapshot_url(
                f"https://files.pharo.org/image/{flat_version}/",
                f"Pharo{version}-SNAPSHOT.build.{build}",
            )
        if not download_url:
            print(f"Could not find download URL for version {version}, build {build}.")
            sys.exit(1)
    else:
        download_url = f"http://files.pharo.org/get-files/{flat_version}/pharo{arch_suffix}.zip"

    print(f"Downloading Pharo {version} from {download_url}")
    download_without_progress(download_url, keep_file_name)

    # Handle backup logic
    if os.path.isdir(dest_dir):
        if kill:
            backup_dir = f"{dest_dir}~"
            if os.path.exists(backup_dir):
                shutil.rmtree(backup_dir)
            shutil.move(dest_dir, backup_dir)
        else:
            img_path = os.path.join(dest_dir, f"{image_name}.image")
            chg_path = os.path.join(dest_dir, f"{image_name}.changes")
            for path in (img_path, chg_path):
                if os.path.exists(path):
                    shutil.move(path, f"{path}~")

    os.makedirs(dest_dir, exist_ok=True)

    # Unzip image
    print(f"Extracting {keep_file_name} into {dest_dir}")
    with zipfile.ZipFile(keep_file_name, "r") as zip_ref:
        for member in zip_ref.namelist():
            if member.endswith((".image", ".changes", ".sources")):
                target_path = os.path.join(dest_dir, os.path.basename(member))
                with zip_ref.open(member, "r") as src, open(target_path, "wb") as dst:
                    shutil.copyfileobj(src, dst)

    # Rename Pharo.image / Pharo.changes to the custom image name
    for fname in os.listdir(dest_dir):
        if fname.startswith("Pharo") and fname.endswith(".image"):
            os.rename(
                os.path.join(dest_dir, fname),
                os.path.join(dest_dir, f"{image_name}.image"),
            )
        elif fname.startswith("Pharo") and fname.endswith(".changes"):
            os.rename(
                os.path.join(dest_dir, fname),
                os.path.join(dest_dir, f"{image_name}.changes"),
            )

    # Optional phconfig execution
    for candidate in [f"{image_name}.st", "config.st"]:
        candidate_path = os.path.join(dest_dir, candidate)
        if os.path.isfile(candidate_path):
            print(f"Running phconfig on {candidate_path}")
            run(["phconfig", os.path.join(dest_dir, f"{image_name}.image"), candidate])
            break

    print("✅ Done.")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Download and prepare a Pharo image."
    )
    parser.add_argument(
        "-v", "--version", default=DEFAULT_VERSION,
        help="Version number to download (default: 14.0)"
    )
    parser.add_argument("-b", "--build", help="Download a particular build (unused)")
    parser.add_argument("-d", "--dest-dir", help="Destination directory")
    parser.add_argument("-n", "--name", help="Image name")
    parser.add_argument(
        "-i", "--issue", type=int,
        help="Equivalent to -d issueNUMBER"
    )
    parser.add_argument(
        "-k", "--kill", action="store_true",
        help="Kill existing previous directory"
    )

    args = parser.parse_args()

    version = args.version
    build = args.build

    if version not in SUPPORTED_VERSIONS:
        print(f"Version {version} not supported.")
        sys.exit(1)

    flat_version = version.replace(".", "")

    # Determine destination directory
    if args.issue:
        dest_dir = f"issue{args.issue}"
    elif args.dest_dir:
        dest_dir = args.dest_dir
    else:
        dest_dir = f"{DEFAULT_DIR_PREFIX}{flat_version}"

    image_name = args.name or dest_dir

    prepare_image(
        version=version,
        build=build,
        dest_dir=buid,
        image_name=image_name,
        kill=args.kill)
