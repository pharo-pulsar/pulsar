<p align="center">
  <img src="resources/logos/pharo.png" width="180" alt="Pharo logo">
  <img src="resources/logos/pulsar.png" width="180" alt="Pulsar logo">
</p>

<h1 align="center">Pulsar</h1>

<p align="center">
  <strong>A coding-first IDE for Pharo.</strong>
</p>

Pulsar brings Pharo's live, reflective development model into a focused,
project-oriented workspace. It combines the tools expected from a contemporary
IDE—editors, navigation, version control, tests, diagnostics, files and
terminals—without giving up the immediacy of working inside a live image.

Pulsar is built with Spec, GTK 4 and libadwaita, and is designed to feel at 
home on the desktop rather than like an isolated world of its own.

> **Project status:** Pulsar is under active development. Nightly builds are
> available, but there is no stable release yet and some workflows are still
> evolving. Please report rough edges: early feedback is especially useful now.

Pulsar was presented at ESUG 2026, where it received first prize in the
Innovation Awards.

## What is in Pulsar today?

- A project and package browser with tabbed class and method editors.
- Fast navigation across projects, packages, classes, methods and open editors.
- Integrated Git repositories, branches, working changes and history.
- A test runner, code critiques and source-change recovery tools.
- Live debugging, inspection, playgrounds and transcripts.
- File-system browsing and integration with native terminals.
- Extensible panels and early integrations for CLI coding agents.

Pulsar is not an attempt to make Pharo behave like a conventional static
language. The goal is to give its live environment a coherent, efficient
workspace for everyday development—and to make the path from writing code to
understanding its effects as short as possible.

## Install

The installer downloads the latest nightly Pulsar image and, with `-m`, a
compatible Pharo VM. It creates a `pulsar` launcher in the current directory.

### Linux

You need `curl`, `tar` and
[Flatpak](https://flatpak.org/setup/) installed on the host.

```bash
mkdir -p pulsar && cd pulsar
curl -L https://forge.smallworks.eu/pharo/Pulsar-installers/raw/branch/main/install-linux.sh \
  | bash -s -- -m
./pulsar
```

The VM is installed as a per-user Flatpak. The bundle includes the native
libraries Pulsar needs, so it does not interfere with libraries installed by
the traditional Pharo ZeroConf distribution.

### macOS

```bash
mkdir -p pulsar && cd pulsar
curl -L https://forge.smallworks.eu/pharo/Pulsar-installers/raw/branch/main/install-macos.sh \
  | bash -s -- -m
./pulsar
```

### Windows

The native Windows distribution is temporarily unavailable because of a
limitation in the current FFI architecture. Until that is resolved, Pulsar can
run through WSL.

On an Ubuntu or Debian WSL installation, prepare Flatpak support first:

```bash
curl -L https://forge.smallworks.eu/pharo/Pulsar-installers/raw/branch/main/support/setup-pulsar-wsl-flatpak.sh \
  | bash
```

Then follow the Linux installation instructions above.

### Installer options

Use `-d <directory>` to choose a destination, `-v YYYY-MM-DD` to install a
particular nightly, and `-o` to replace an existing installation. See the
[installer repository](https://forge.smallworks.eu/pharo/Pulsar-installers)
for complete usage and platform notes.

Nightly packages can also be
[downloaded directly](https://forge.smallworks.eu/pharo/-/packages/generic/pulsar-nightly-build).

## Run Pulsar with an existing VM

On Linux, omit `-m` if a compatible `pharo` command is already available:

```bash
curl -L https://forge.smallworks.eu/pharo/Pulsar-installers/raw/branch/main/install-linux.sh \
  | bash
./pulsar
```

Do not use the ZeroConf VM for Pulsar: its bundled libraries can take
precedence over the GTK stack Pulsar expects.

The underlying command is:

```bash
pharo --worker Pulsar.image openPulsar
```

## Build from source

You do not need to build Pulsar to use it; the nightly pipeline produces a
ready-to-run image every day.

Pulsar currently targets Pharo 14. Its build requires GTK 4, GtkSourceView 5,
libadwaita, libpanel, librsvg and VTE, plus SSH access to the project
dependencies hosted on the Smallworks forge.

The authoritative build process lives in [`.ci/scripts`](.ci/scripts). In an
environment with those dependencies and a compatible `pharo` command:

```bash
git clone https://forge.smallworks.eu/pharo/Pulsar.git
cd Pulsar
mkdir build && cd build
python3 ../.ci/scripts/build.py
```

The resulting archive is written below `build/dist/`.

## Contributing

Pulsar is at a stage where testing, bug reports, design feedback and code are
all valuable. If something breaks—or if a workflow feels heavier than it
should—please [open an issue](https://forge.smallworks.eu/pharo/Pulsar/issues).

For code contributions:

1. Create a branch from `main`.
2. Keep the change focused and include tests when appropriate.
3. Open a pull request explaining the problem and the chosen approach.

## License

Pulsar is distributed under the
[GNU General Public License v3.0](LICENSE).

The bundled [Material Design Icons](LICENSE-Templarian-MDI) and
[file-type icons](LICENSE-FileType-icons) retain their respective licenses.
