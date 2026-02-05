#!/usr/bin/env python3
import buildenv
import pharoget
import subprocess

from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
REPOSITORY_DIR = SCRIPT_DIR.parent.parent

def run(cmd):
    """Run shell command safely."""
    
    print(f"+ {' '.join(cmd)}")
    subprocess.run(cmd, check=True)

def evaluate_pharo_script(filename):
    """Run a Pharo command safely."""

    print("🏃‍➡️ Evaluating: ", filename)

    script = f"OpalCompiler new source: ('{filename}' asFileReference contents); evaluate."

    run([
        "pharo", 
        "--headless", 
        f"{buildenv.DEST_DIR}/{buildenv.DEST_IMAGE_NAME}.image", 
        "--no-default-preferences",
        "eval",
        "--save",           
        script ])

    print("✅ Done.")

def cleanup_local():
    print("🧹 Cleaning up local directories")
    run(["rm", "-rf", f"{buildenv.DEST_DIR}/pharo-local"])
    print("✅ Done.")

def prepare_tarball():
    
    print("📦 Preparing tarball")
    
    dest = Path(buildenv.DEST_DIR)
    sources = list(dest.glob("Pharo*.sources"))

    if len(sources) != 1:
        raise RuntimeError(f"Expected exactly one Pharo*.sources file, found {sources}")

    run([
        "tar", 
        "-czf", 
        "-C", buildenv.DEST_DIR,        
        f"{buildenv.DEST_IMAGE_NAME}.tar.gz", 
        f"{buildenv.DEST_IMAGE_NAME}.image", 
        f"{buildenv.DEST_IMAGE_NAME}.changes", 
        sources[0].name, 
        "resources"])

    print("✅ Done.")

def copy_resources():
    print("📦 Copying resources")
    run(["cp", "-r", f"{REPOSITORY_DIR}/resources", f"{buildenv.DEST_DIR}"])
    print("✅ Done.")

def main() -> None:
  
    # Download the Pulsar image  
    print("🌐 Downloading Pulsar image")
    pharoget.prepare_image(
        dest_dir=buildenv.DEST_DIR, 
        image_name=buildenv.DEST_IMAGE_NAME, 
        build=buildenv.BUILD_IMAGE_VERSION, 
        kill=True)

    # Evaluate the scripts
    print("Evaluating configuration scripts")
    for script in [ "PreLoad.st", "Load.st", "PostLoad.st" ]:
        evaluate_pharo_script(f"{SCRIPT_DIR}/{script}")
    print("✅ Done script processing.")
    
    copy_resources()

    # not really needed
    # cleanup_local()

    prepare_tarball()

    print("✅ Done.")


if __name__ == "__main__":
    main()