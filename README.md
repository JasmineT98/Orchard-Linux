# Orchard Linux B2

B2 is a clean replacement of the B1 project. It keeps the proven lightweight live desktop while broadening out-of-box hardware support.

The hardware rule is simple: **the Linux kernel handles generic drivers; Orchard ships the firmware and user-space services those kernel drivers need.**

## Target
- x86-64 Windows PCs and laptops
- compatible x86-64 Chromebooks that can boot a standard amd64 Linux image
- Intel and AMD CPUs
- broad Intel/AMD/NVIDIA open graphics path
- common Intel, Realtek, Atheros, Broadcom/Cypress, MediaTek/Ralink and Marvell wireless hardware
- PipeWire audio, Bluetooth, storage, sensors, power and removable media

## Build
```bash
sudo ./build.sh
```
Output:
```text
out/orchard-linux-b2-amd64.iso
out/orchard-linux-b2-amd64.iso.sha256
```

## Current UI
B2 still uses the lightweight Labwc/Waybar/Wofi prototype while the final Orchard shell is developed. The top-left orange Orchard mark now opens a system menu, while **Applications** opens the app launcher.

Orchard uses macOS-style shortcut behavior as its baseline. On typical PC keyboards the Windows/Super key acts as the Orchard Command key; on Chromebook hardware the Search/Launcher key can fill that role when mapped by the input stack.

B2 is amd64 only. ARM Chromebooks need a separate arm64 build and device-specific boot work.
