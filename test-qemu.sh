#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ISO="$ROOT/out/orchard-linux-b2-amd64.iso"
[[ -f "$ISO" ]] || { echo "Build the ISO first with: sudo ./build-b2.sh" >&2; exit 1; }
command -v qemu-system-x86_64 >/dev/null || { echo "Install QEMU: sudo apt install qemu-system-x86" >&2; exit 1; }
ACCEL=(-cpu max)
if [[ -r /dev/kvm && -w /dev/kvm ]]; then ACCEL=(-enable-kvm -cpu host); fi
qemu-system-x86_64 \
  "${ACCEL[@]}" \
  -m 4096 \
  -smp 2 \
  -device virtio-vga \
  -display gtk \
  -device intel-hda -device hda-duplex \
  -nic user,model=virtio-net-pci \
  -cdrom "$ISO" \
  -boot d
