#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

bash -n build-b2.sh clean.sh test-qemu.sh \
  config/includes.chroot/etc/skel/.config/labwc/autostart \
  config/includes.chroot/usr/local/bin/orchard-session \
  config/includes.chroot/usr/local/bin/apply-appearance \
  config/includes.chroot/usr/local/bin/orchard-hardware-profile \
  config/includes.chroot/usr/local/lib/orchard/appstore-helper \
  config/hooks/live/010-orchard-defaults.hook.chroot

python3 -m py_compile \
  config/includes.chroot/usr/lib/orchard/ui.py \
  config/includes.chroot/usr/local/bin/settings \
  config/includes.chroot/usr/local/bin/files \
  config/includes.chroot/usr/local/bin/text-editor \
  config/includes.chroot/usr/local/bin/calculator \
  config/includes.chroot/usr/local/bin/app-store

python3 - <<'PYCHECK'
import json, pathlib, xml.etree.ElementTree as ET
root=pathlib.Path('.')
assert (root/'VERSION').read_text().strip() == 'B2'
json.load(open(root/'config/includes.chroot/etc/skel/.config/waybar/config.json'))
ET.parse(root/'config/includes.chroot/etc/skel/.config/labwc/rc.xml')
required = {
    'amd64-microcode','intel-microcode','firmware-amd-graphics','firmware-intel-graphics',
    'firmware-nvidia-graphics','firmware-atheros','firmware-brcm80211','firmware-mediatek',
    'firmware-sof-signed','alsa-ucm-conf','switcheroo-control','iio-sensor-proxy','fwupd'
}
pkgs=set()
for line in (root/'b2-hardware-packages.txt').read_text().splitlines():
    line=line.split('#',1)[0].strip()
    if line: pkgs.add(line)
missing=sorted(required-pkgs)
assert not missing, f'B2 hardware package set incomplete: {missing}'
print('B2 static validation passed.')
PYCHECK
