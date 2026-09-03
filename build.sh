#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD="$ROOT/build"
OUT="$ROOT/out"
PKGLIST="$ROOT/config/package-lists/orchard.list.chroot"

if [[ $EUID -ne 0 ]]; then
  echo "Run with sudo: sudo ./build.sh" >&2
  exit 1
fi

if [[ ! -r /etc/os-release ]]; then
  echo "Cannot detect build host." >&2
  exit 1
fi

. /etc/os-release
if [[ "${ID:-}" != "debian" || "${VERSION_CODENAME:-}" != "trixie" ]]; then
  echo "Warning: Orchard is validated on Debian 13 (trixie). Continuing anyway." >&2
fi

apt-get update

if ! command -v lb >/dev/null 2>&1; then
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    live-build debootstrap xorriso squashfs-tools
fi

missing=()
while IFS= read -r pkg; do
  pkg="${pkg%%#*}"
  pkg="$(echo "$pkg" | xargs)"
  [[ -z "$pkg" ]] && continue
  apt-cache show "$pkg" >/dev/null 2>&1 || missing+=("$pkg")
done < "$PKGLIST"

if ((${#missing[@]})); then
  printf 'Missing Debian packages: %s\n' "${missing[*]}" >&2
  exit 1
fi

find "$ROOT/config/hooks" -type f -name '*.hook.chroot' -exec chmod +x {} +
find "$ROOT/config/includes.chroot/usr/local/bin" -type f -exec chmod +x {} +
chmod +x "$ROOT/config/includes.chroot/etc/skel/.config/labwc/autostart"

rm -rf "$BUILD"
mkdir -p "$BUILD" "$OUT"
cp -a "$ROOT/config" "$BUILD/config"
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

cp -f "$ISO" "$OUT/orchard-linux-amd64.iso"
(
  cd "$OUT"
  sha256sum orchard-linux-amd64.iso > orchard-linux-amd64.iso.sha256
)

echo
echo "Orchard ISO ready: $OUT/orchard-linux-amd64.iso"
