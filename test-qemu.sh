#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ISO="$ROOT/out/orchard-linux-amd64.iso"
test -f "$ISO" || { echo "Build the ISO first."; exit 1; }
ACCEL=(-cpu max)
if [[ -r /dev/kvm && -w /dev/kvm ]]; then
  ACCEL=(-enable-kvm -cpu host)
fi
qemu-system-x86_64 "${ACCEL[@]}" -m 4096 -smp 2 \
  -device virtio-vga -display gtk \
  -device intel-hda -device hda-duplex \
  -nic user,model=virtio-net-pci \
  -cdrom "$ISO" -boot d
