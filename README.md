# Orchard Linux

**Current development build: B2**

Orchard Linux is a lightweight desktop operating system designed to provide a
macOS-familiar experience on ordinary PC hardware while using Orchard-made
branding, artwork, icons, code, and shell components.

B2 focuses first on hardware stability. The Linux kernel handles the majority
of generic hardware drivers; Orchard adds the firmware and standard Linux
hardware services those drivers commonly require.

## B2 priorities

- Broad x86-64 PC and laptop hardware support
- Compatible x86-64 Chromebook support
- Intel and AMD CPU microcode
- Broad Wi-Fi, Bluetooth, audio, graphics, USB, storage, and laptop support
- Preserve the fast live-session behavior proven by the previous working build
- Keep the current lightweight shell while the final Orchard shell is developed
- Permanent project filenames that do not change between builds

## Build locally

On Debian 13:

```bash
sudo ./build.sh
```

Output:

```text
out/orchard-linux-amd64.iso
out/orchard-linux-amd64.iso.sha256
```

## Cloud build

The permanent GitHub Actions workflow is:

```text
.github/workflows/build-iso.yml
```

It produces the permanent artifact name:

```text
orchard-linux-amd64
```

## Stable backup

`.orchard-backup` contains the Git commit that has been explicitly confirmed
stable. Updating that file triggers the backup workflow, which moves the
`backup/last-working` branch to that confirmed commit.

A new upload is never considered stable automatically.
