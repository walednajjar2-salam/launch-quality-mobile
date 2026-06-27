$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot -Parent
$rail = Join-Path $env:USERPROFILE 'Projects\Launch-Quality-Railway-Deploy\public'
$src = Join-Path $repo 'release'
$dl = Join-Path $rail 'downloads'
$assets = Join-Path $rail 'assets'

if (-not (Test-Path $rail)) {
  throw "Railway deploy folder not found: $rail"
}

New-Item -ItemType Directory -Force -Path $dl, $assets | Out-Null

Copy-Item (Join-Path $src 'Launch-Quality-Staff.apk') (Join-Path $dl 'Launch-Quality-Staff.apk') -Force
Copy-Item (Join-Path $src 'Launch-Quality-Staff-Windows.zip') (Join-Path $dl 'Launch-Quality-Staff-Windows.zip') -Force
Copy-Item (Join-Path $repo 'assets\logo.png') (Join-Path $assets 'brand-logo-gold.png') -Force

python (Join-Path $PSScriptRoot 'generate-app-icons.py')
python -c @"
from PIL import Image
from pathlib import Path
logo = Image.open(r'$($repo -replace '\\','\\')\\assets\\logo.png').convert('RGBA')
BG = (6, 17, 31, 255)
assets = Path(r'$($assets -replace '\\','\\')')
for size, name in [(192, 'app-icon-192.png'), (512, 'app-icon-512.png')]:
    inner = int(size * 0.78)
    im = logo.copy()
    im.thumbnail((inner, inner), Image.Resampling.LANCZOS)
    canvas = Image.new('RGBA', (size, size), BG)
    canvas.paste(im, ((size - im.width) // 2, (size - im.height) // 2), im)
    canvas.save(assets / name, optimize=True)
"@

Write-Host "Synced downloads to Railway public/downloads"
Write-Host "Deploy jawdah-cloud-v47 to activate direct links on production."
