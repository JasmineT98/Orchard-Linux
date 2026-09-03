#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

test -f README.md
test -f .orchard-backup
test ! -e VERSION

bash -n build.sh clean.sh test-qemu.sh \
  config/includes.chroot/etc/skel/.config/labwc/autostart \
  config/includes.chroot/usr/local/bin/orchard-session \
  config/includes.chroot/usr/local/bin/orchard-system-menu \
  config/includes.chroot/usr/local/bin/orchard-hardware-report \
  config/hooks/live/010-orchard-defaults.hook.chroot

python3 -m py_compile \
  config/includes.chroot/usr/lib/orchard/ui.py \
  config/includes.chroot/usr/local/bin/settings \
  config/includes.chroot/usr/local/bin/files \
  config/includes.chroot/usr/local/bin/text-editor \
  config/includes.chroot/usr/local/bin/calculator \
  config/includes.chroot/usr/local/bin/app-store

python3 - <<'PYCHECK'
import json
import pathlib
import xml.etree.ElementTree as ET

root = pathlib.Path(".")
json.load(open(root / "config/includes.chroot/etc/skel/.config/waybar/config.json"))
ET.parse(root / "config/includes.chroot/etc/skel/.config/labwc/rc.xml")

pkgs = set()
for line in (root / "config/package-lists/orchard.list.chroot").read_text().splitlines():
    line = line.split("#", 1)[0].strip()
    if line:
        pkgs.add(line)

required = {
    "linux-image-amd64",
    "firmware-linux",
    "firmware-iwlwifi",
    "firmware-realtek",
    "firmware-atheros",
    "firmware-brcm80211",
    "firmware-mediatek",
    "firmware-libertas",
    "firmware-intel-sound",
    "firmware-sof-signed",
    "intel-microcode",
    "amd64-microcode",
    "network-manager",
    "bluez",
    "pipewire",
    "wireplumber",
    "mesa-va-drivers",
    "mesa-vulkan-drivers",
}
missing = sorted(required - pkgs)
assert not missing, f"Required hardware packages missing: {missing}"
print("Orchard static validation passed.")
PYCHECK
