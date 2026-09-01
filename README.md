# Orchard Linux B1

**Base:** Debian 13.6 (trixie) Stable, amd64  
**Goal:** an extremely lightweight, modern, macOS-inspired Linux desktop with a unified visual language.

B1 is intentionally a **live ISO**. Boot it in a VM or from USB before installing anything to disk.

## What B1 includes

- Labwc Wayland compositor with XWayland compatibility
- Waybar top panel + lightweight bottom dock
- Wofi launcher
- Unified GTK 3 / GTK 4 styling
- Qt compatibility via Kvantum/Qt6ct
- XDG desktop portals for consistent dialogs and Flatpak integration
- Matching LightDM live login styling
- Flatpak support
- Lightweight built-in apps with simple labels:
  - Files
  - Settings
  - App Store
  - Text Editor
  - Calculator
  - Terminal
- NetworkManager, PipeWire/WirePlumber, Bluetooth, battery controls
- ZRAM and conservative low-memory defaults
- Orange system mark (not an Apple logo)

## Build the ISO

Use a Debian 13 (trixie) amd64 machine or VM with internet access.

```bash
sudo ./build-b1.sh
```

The finished image will be copied to:

```text
out/orchard-linux-b1-amd64.iso
```

The script installs `live-build` automatically if necessary.

## Test in QEMU

```bash
./test-qemu.sh
```

If QEMU is not installed:

```bash
sudo apt install qemu-system-x86
```

## Write to USB

**Warning: this erases the selected device.** Replace `/dev/sdX` with the whole USB device, not a partition.

```bash
sudo dd if=out/orchard-linux-b1-amd64.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

## B1 limitations

This is the first integration build, not a finished distribution. The App Store has a deliberately small curated catalog. Flatpak apps inherit system color-scheme/portal integration where their toolkit supports it, but applications that draw their own interface (Electron, games, Blender, etc.) cannot be forced to look identical without patching them.

B1 does not include a disk installer; it is designed for safe live testing first.

## Cloud build (no build computer needed)

B1 includes a GitHub Actions workflow at `.github/workflows/build-iso.yml`.
Upload this project to a GitHub repository, open **Actions -> Build B1 ISO -> Run workflow**,
and GitHub will build the ISO inside Debian 13 and return the ISO plus SHA-256 checksum
as a downloadable workflow artifact. See `CLOUD-BUILD.md`.
