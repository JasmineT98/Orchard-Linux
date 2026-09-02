# Orchard B2 cloud build

The repository includes `.github/workflows/build-iso.yml`.

1. Replace the repository contents with this B2 project.
2. Open **Actions -> Build B2 ISO**.
3. Run the workflow, or let the push to `main` trigger it.
4. Download the `orchard-linux-b2-amd64` artifact.
5. Extract the ISO and SHA-256 checksum.

The workflow builds inside a Debian 13 container and verifies the checksum before upload.
