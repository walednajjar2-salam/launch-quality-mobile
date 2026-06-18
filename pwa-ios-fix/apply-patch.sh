#!/usr/bin/env bash
# Apply PWA head tags to index.html (run inside jawdah-cloud-v47 clone)
set -euo pipefail
FILE="${1:-public/index.html}"
if [[ ! -f "$FILE" ]]; then echo "Missing $FILE"; exit 1; fi
python3 << 'PY'
from pathlib import Path
p = Path("public/index.html")
text = p.read_text(encoding="utf-8")
snippet = '''
  <meta name="theme-color" content="#1e293b">
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
  <meta name="apple-mobile-web-app-title" content="Launch Quality">
  <link rel="icon" href="/favicon.ico" sizes="any">
  <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32.png">
  <link rel="apple-touch-icon" href="/apple-touch-icon.png">
  <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
  <link rel="manifest" href="/manifest.webmanifest">
'''
if "apple-touch-icon" in text:
    print("Already patched")
else:
    text = text.replace('<title>Quality of Launch Services LLC</title>', '<title>Quality of Launch Services LLC</title>' + snippet, 1)
    text = text.replace('width="width=device-width,initial-scale=1"', 'width="width=device-width,initial-scale=1,viewport-fit=cover"', 1)
    p.write_text(text, encoding="utf-8")
    print("Patched", p)
PY
