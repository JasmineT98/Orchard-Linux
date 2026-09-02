#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD="$ROOT/build"
OUT="$ROOT/out"
BASE_PACKAGES="$ROOT/config/package-lists/orchard.list.chroot"
B2_PACKAGES="$ROOT/b2-hardware-packages.txt"

if [[ $EUID -ne 0 ]]; then
  echo "Run this with sudo: sudo ./build-b2.sh" >&2
  exit 1
fi

if [[ ! -r /etc/os-release ]]; then
  echo "Cannot detect build host." >&2
  exit 1
fi
. /etc/os-release
if [[ "${ID:-}" != "debian" || "${VERSION_CODENAME:-}" != "trixie" ]]; then
  echo "Warning: B2 is validated for Debian 13 (trixie). Continuing anyway." >&2
fi

apt-get update

if ! command -v lb >/dev/null 2>&1; then
  DEBIAN_FRONTEND=noninteractive apt-get install -y live-build debootstrap xorriso squashfs-tools
fi

# Validate both the proven B1 base packages and B2's extra hardware packages.
missing=()
for list in "$BASE_PACKAGES" "$B2_PACKAGES"; do
  while IFS= read -r pkg; do
    pkg="${pkg%%#*}"
    pkg="$(echo "$pkg" | xargs)"
    [[ -z "$pkg" ]] && continue
    apt-cache show "$pkg" >/dev/null 2>&1 || missing+=("$pkg")
  done < "$list"
done
if ((${#missing[@]})); then
  printf 'Missing Debian packages: %s\n' "${missing[*]}" >&2
  exit 1
fi

rm -rf "$BUILD"
mkdir -p "$BUILD" "$OUT"
cp -a "$ROOT/config" "$BUILD/config"
# Add B2 hardware packages only to the B2 build copy. B1's package list stays untouched.
cp "$B2_PACKAGES" "$BUILD/config/package-lists/orchard-b2-hardware.list.chroot"
cd "$BUILD"

lb config \
  --mode debian \
  --distribution trixie \
  --architectures amd64 \
  --archive-areas "main contrib non-free non-free-firmware" \
  --binary-images iso-hybrid \
  --debian-installer none \
  --memtest none \
  --apt-recommends true \
  --bootappend-live "boot=live components quiet splash username=user hostname=orchard locales=en_US.UTF-8 keyboard-layouts=us"

lb build

ISO="$(find . -maxdepth 1 -type f -name '*.iso' | head -n1)"
if [[ -z "$ISO" ]]; then
  echo "Build completed but no ISO was found." >&2
  exit 1
fi

cp -f "$ISO" "$OUT/orchard-linux-b2-amd64.iso"
(
  cd "$OUT"
  sha256sum orchard-linux-b2-amd64.iso > orchard-linux-b2-amd64.iso.sha256
)

echo
echo "B2 ISO ready: $OUT/orchard-linux-b2-amd64.iso"
