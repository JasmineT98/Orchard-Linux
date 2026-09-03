#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

test -f README.md
test -f .orchard-backup
test ! -e VERSION
test -f .github/workflows/build-iso.yml
test -f .github/workflows/backup.yml
test -f config/includes.chroot/usr/lib/python3/dist-packages/orchard/__init__.py

bash -n \
  build.sh clean.sh test-qemu.sh \
  config/includes.chroot/etc/skel/.config/labwc/autostart \
  config/includes.chroot/usr/local/bin/orchard-session \
  config/includes.chroot/usr/local/bin/orchard-browser \
  config/includes.chroot/usr/local/bin/orchard-set-gap \
  config/includes.chroot/usr/local/bin/orchard-screenshot-full \
  config/includes.chroot/usr/local/bin/orchard-screenshot-area \
  config/includes.chroot/usr/local/libexec/orchard-install-package \
  config/includes.chroot/usr/local/libexec/orchard-update-helper \
  config/hooks/live/010-orchard-defaults.hook.chroot \
  config/hooks/live/020-orchard-shell-smoke-test.hook.chroot

python3 - <<'PY'
import pathlib
import py_compile
import xml.etree.ElementTree as ET

root = pathlib.Path(".")
ET.parse(root / "config/includes.chroot/etc/skel/.config/labwc/rc.xml")

scripts = [
    "config/includes.chroot/usr/lib/python3/dist-packages/orchard/__init__.py",
    "config/includes.chroot/usr/lib/python3/dist-packages/orchard/ui.py",
    "config/includes.chroot/usr/local/bin/orchard-shell",
    "config/includes.chroot/usr/local/bin/orchard-launcher",
    "config/includes.chroot/usr/local/bin/orchard-system-menu",
    "config/includes.chroot/usr/local/bin/orchard-control-center",
    "config/includes.chroot/usr/local/bin/orchard-notification-center",
    "config/includes.chroot/usr/local/bin/wifi-settings",
    "config/includes.chroot/usr/local/bin/settings",
    "config/includes.chroot/usr/local/bin/files",
    "config/includes.chroot/usr/local/bin/notes",
    "config/includes.chroot/usr/local/bin/text-editor",
    "config/includes.chroot/usr/local/bin/calculator",
    "config/includes.chroot/usr/local/bin/app-store",
    "config/includes.chroot/usr/local/bin/calendar",
    "config/includes.chroot/usr/local/bin/contacts",
    "config/includes.chroot/usr/local/bin/clock",
    "config/includes.chroot/usr/local/bin/photos",
    "config/includes.chroot/usr/local/bin/activity-monitor",
    "config/includes.chroot/usr/local/bin/system-info",
    "config/includes.chroot/usr/local/bin/software-update",
    "config/includes.chroot/usr/local/bin/orchard-recovery",
    "config/includes.chroot/usr/local/bin/orchard-lock",
]
for f in scripts:
    py_compile.compile(str(root / f), doraise=True)

assert "Current development build: B2" in (root / "README.md").read_text()
print("Orchard static validation passed.")
PY
