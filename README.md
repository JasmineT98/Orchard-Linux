# Orchard Linux

**Current development build: B2**

Orchard Linux is a lightweight desktop operating system for ordinary x86-64
PC hardware. It uses a standard Linux kernel and hardware stack underneath,
while Orchard owns the visible desktop experience.

This B2 overhaul replaces the prototype Waybar/Wofi desktop chrome with the
Orchard shell itself.

## Visible Orchard shell

The normal session now contains:

- Orchard top menu bar
- Orchard Dock
- Orchard system menu
- Orchard Search / Applications launcher
- Orchard Control Center
- Orchard Notification Center
- Graphical Wi-Fi controls
- Graphical Settings
- Orchard lock screen styling
- macOS-familiar Command / Windows / Search keyboard behavior
- macOS-style edge/corner snap previews and usable-area tiling
- Orchard recovery panel
- first-party Files, Browser launcher, Notes, Text Editor, Calculator,
  App Store, Calendar, Contacts, Clock, Photos, Activity Monitor,
  System Information, Software Update and Settings

The visible shell is Orchard-made. No Apple logos, Apple artwork, Apple icons,
Apple proprietary UI resources or Apple code are included.

## Architecture

```text
Orchard Shell / Apps
        ↓
standard Linux user-space interfaces
        ↓
NetworkManager / BlueZ / PipeWire / UPower / UDisks / XDG
        ↓
Labwc compatibility compositor
        ↓
Linux kernel + firmware
```

Labwc is the hidden window-management backend for B2. The top bar, Dock,
launcher and system panels are Orchard components.

## Hardware philosophy

The Linux kernel handles the majority of generic hardware drivers. Orchard
ships the firmware, microcode and standard services those drivers commonly
require.

## Build

```bash
sudo ./build.sh
```

Permanent output names:

```text
out/orchard-linux-amd64.iso
out/orchard-linux-amd64.iso.sha256
```

The GitHub Actions artifact is permanently named:

```text
orchard-linux-amd64
```

## Stable backup policy

`.orchard-backup` remains the last explicitly confirmed stable commit.
Experimental uploads never promote themselves to stable.

## Current boundary

This is still the live/test B2 desktop. A final disk installer remains a
separate phase rather than being silently added before the live desktop and
hardware behavior are confirmed stable.
