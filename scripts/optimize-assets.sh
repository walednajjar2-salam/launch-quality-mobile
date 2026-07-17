#!/bin/bash
# optimize-assets.sh
# Compress image assets to reduce app size.
# Requires: optipng, jpegoptim, cwebp (install via your OS package manager).

set -euo pipefail

ASSETS_DIR="$(dirname "$0")/../assets"

echo "🖼️  Optimizing assets..."

# Compress PNG files (optimization level 2 – fast and effective)
if command -v optipng &>/dev/null; then
  find "$ASSETS_DIR" -name "*.png" -exec optipng -o2 {} \;
  echo "✅ PNG files optimized"
else
  echo "⚠️  optipng not found – skipping PNG optimization"
fi

# Compress JPEG files (max quality 85)
if command -v jpegoptim &>/dev/null; then
  find "$ASSETS_DIR" -name "*.jpg" -exec jpegoptim --max=85 {} \;
  find "$ASSETS_DIR" -name "*.jpeg" -exec jpegoptim --max=85 {} \;
  echo "✅ JPEG files optimized"
else
  echo "⚠️  jpegoptim not found – skipping JPEG optimization"
fi

# Convert large PNG files to WebP (quality 80)
if command -v cwebp &>/dev/null; then
  mkdir -p "$ASSETS_DIR/compressed"
  for f in "$ASSETS_DIR"/*.png; do
    [ -f "$f" ] || continue
    base="$(basename "$f" .png)"
    cwebp -q 80 "$f" -o "$ASSETS_DIR/compressed/${base}.webp"
  done
  echo "✅ PNG → WebP conversion complete"
else
  echo "⚠️  cwebp not found – skipping WebP conversion"
fi

echo "✅ Asset optimization complete"
