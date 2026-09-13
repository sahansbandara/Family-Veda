#!/usr/bin/env bash
# Regenerate every app and web icon from the vector marks in brand/dist/.
#
#   ./brand/generate-icons.sh
#
# Sources:
#   brand/dist/mark.svg        heart + shield + cross  -> app icons, apple-touch
#   brand/dist/mark-small.svg  heart + cross           -> favicon sizes
#
# Requires: ImageMagick (magick) and macOS qlmanage for SVG rasterisation.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST="$ROOT/brand/dist"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

command -v magick >/dev/null || { echo "error: ImageMagick 'magick' not found"; exit 1; }
command -v qlmanage >/dev/null || { echo "error: 'qlmanage' not found (macOS only)"; exit 1; }

# Rasterise an SVG to a square transparent PNG at the given edge length.
render() {           # render <svg-path> <size> <out-png>
  local svg="$1" size="$2" out="$3"
  qlmanage -t -s "$size" -o "$TMP" "$svg" >/dev/null 2>&1
  magick "$TMP/$(basename "$svg").png" -resize "${size}x${size}" \
         -background none -gravity center -extent "${size}x${size}" "$out"
}

# Mark on an opaque square, inset by a padding percentage.
plate() {            # plate <src-png> <size> <pad%> <bg> <out-png>
  local src="$1" size="$2" pad="$3" bg="$4" out="$5"
  local inner=$(( size * (100 - 2 * pad) / 100 ))
  magick "$src" -resize "${inner}x${inner}" \
         -background "$bg" -gravity center -extent "${size}x${size}" \
         -alpha remove -alpha off "$out"
}

echo "==> rasterising vector marks"
render "$DIST/mark.svg"        1024 "$TMP/mark1024.png"
render "$DIST/mark-small.svg"  1024 "$TMP/small1024.png"

# ── web ────────────────────────────────────────────────────────────────────
WEB="$ROOT/web/public"
echo "==> web/public"
cp "$DIST/mark-small.svg" "$WEB/favicon.svg"

for s in 16 32 48; do
  magick "$TMP/small1024.png" -resize "${s}x${s}" "$TMP/ico-$s.png"
done
magick "$TMP/ico-16.png" "$TMP/ico-32.png" "$TMP/ico-48.png" "$WEB/favicon.ico"

# Apple touch icons must be opaque — iOS composites them on black otherwise.
plate "$TMP/mark1024.png" 180 10 white "$WEB/apple-touch-icon.png"

magick "$TMP/mark1024.png" -resize 192x192 -background none \
       -gravity center -extent 192x192 "$WEB/icon-192.png"
magick "$TMP/mark1024.png" -resize 512x512 -background none \
       -gravity center -extent 512x512 "$WEB/icon-512.png"

# Maskable needs the mark inside the 80% safe zone, on an opaque plate.
plate "$TMP/mark1024.png" 512 20 white "$WEB/icon-maskable-512.png"

# ── android ────────────────────────────────────────────────────────────────
echo "==> android mipmaps"
declare -a AND=( "mdpi:48" "hdpi:72" "xhdpi:96" "xxhdpi:144" "xxxhdpi:192" )
for entry in "${AND[@]}"; do
  dpi="${entry%%:*}"; px="${entry##*:}"
  dir="$ROOT/mobile/android/app/src/main/res/mipmap-$dpi"
  mkdir -p "$dir"
  plate "$TMP/mark1024.png" "$px" 10 white "$dir/ic_launcher.png"
done

# ── ios ────────────────────────────────────────────────────────────────────
echo "==> ios app icon set"
IOS="$ROOT/mobile/ios/Runner/Assets.xcassets/AppIcon.appiconset"
declare -a IOS_ICONS=(
  "Icon-App-20x20@1x.png:20"    "Icon-App-20x20@2x.png:40"    "Icon-App-20x20@3x.png:60"
  "Icon-App-29x29@1x.png:29"    "Icon-App-29x29@2x.png:58"    "Icon-App-29x29@3x.png:87"
  "Icon-App-40x40@1x.png:40"    "Icon-App-40x40@2x.png:80"    "Icon-App-40x40@3x.png:120"
  "Icon-App-60x60@2x.png:120"   "Icon-App-60x60@3x.png:180"
  "Icon-App-76x76@1x.png:76"    "Icon-App-76x76@2x.png:152"
  "Icon-App-83.5x83.5@2x.png:167"
  "Icon-App-1024x1024@1x.png:1024"
)
for entry in "${IOS_ICONS[@]}"; do
  name="${entry%%:*}"; px="${entry##*:}"
  # iOS rejects alpha in app icons.
  plate "$TMP/mark1024.png" "$px" 10 white "$IOS/$name"
done

# ── flutter in-app mark ────────────────────────────────────────────────────
# Rendered inside the app (splash, login), not just as a launcher icon.
# Flutter resolves the 2.0x/ and 3.0x/ variants automatically.
echo "==> flutter in-app mark"
BRAND="$ROOT/mobile/assets/brand"
mkdir -p "$BRAND/2.0x" "$BRAND/3.0x"
magick "$TMP/mark1024.png" -resize 96x96   -background none -gravity center -extent 96x96   "$BRAND/mark.png"
magick "$TMP/mark1024.png" -resize 192x192 -background none -gravity center -extent 192x192 "$BRAND/2.0x/mark.png"
magick "$TMP/mark1024.png" -resize 288x288 -background none -gravity center -extent 288x288 "$BRAND/3.0x/mark.png"

echo "==> done"
