# B1 Cloud Build — no Linux PC required

This repository can build the B1 ISO entirely on GitHub's hosted infrastructure.
The actual live-build process runs inside a privileged Debian 13 container so the
build environment matches the operating-system base.

## First-time setup

1. Create an empty GitHub repository.
2. Upload the contents of this folder to the repository (keep `.github/`).
3. Open the repository's **Actions** tab.
4. Select **Build B1 ISO**.
5. Press **Run workflow**.
6. When the run finishes, open it and download the `orchard-linux-b1-amd64` artifact.
7. Extract the artifact. It contains the `.iso` and its SHA-256 checksum.

## Automatic builds

A build also starts when changes are pushed to `main` that affect the live image,
build scripts, validation, or the workflow itself.

## What is happening

GitHub runner -> privileged Debian 13 container -> Debian live-build -> ISO ->
GitHub Actions artifact.

No local Debian installation is required to compile the ISO.
