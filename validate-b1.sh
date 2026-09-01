#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

bash -n build-b1.sh clean.sh test-qemu.sh \
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
json.load(open(root/'config/includes.chroot/etc/skel/.config/waybar/config.json'))
ET.parse(root/'config/includes.chroot/etc/skel/.config/labwc/rc.xml')
print('B1 static validation passed.')
PYCHECK
