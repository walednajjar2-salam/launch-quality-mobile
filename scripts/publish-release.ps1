$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot -Parent
$tag = 'v1.0.1-staff'
$releaseDir = Join-Path $repo 'release'
$apk = Join-Path $repo 'android\app\build\outputs\apk\release\Launch-Quality-Staff.apk'
$zip = Join-Path $releaseDir 'Launch-Quality-Staff-Windows.zip'

New-Item -ItemType Directory -Force -Path $releaseDir | Out-Null

if (-not (Test-Path $apk)) {
  throw "APK missing: $apk. Run: cd android; .\gradlew.bat assembleRelease"
}
Copy-Item $apk (Join-Path $releaseDir 'Launch-Quality-Staff.apk') -Force

if (-not (Test-Path $zip)) {
  & (Join-Path $PSScriptRoot 'package-windows-release.ps1')
}

$gh = Get-Command gh -ErrorAction SilentlyContinue
if (-not $gh) {
  Write-Host ""
  Write-Host "GitHub CLI (gh) not installed. Upload manually:"
  Write-Host "  https://github.com/walednajjar2-salam/launch-quality-mobile/releases/new?tag=$tag"
  Write-Host "  Attach: $releaseDir\Launch-Quality-Staff.apk"
  Write-Host "          $releaseDir\Launch-Quality-Staff-Windows.zip"
  exit 0
}

gh release view $tag --repo walednajjar2-salam/launch-quality-mobile 2>$null
if ($LASTEXITCODE -ne 0) {
  gh release create $tag `
    --repo walednajjar2-salam/launch-quality-mobile `
    --title "Launch Quality Staff v1.0.1" `
    --notes "Organization logo icon + direct Android and Windows download links."
}

gh release upload $tag `
  --repo walednajjar2-salam/launch-quality-mobile `
  --clobber `
  (Join-Path $releaseDir 'Launch-Quality-Staff.apk') `
  (Join-Path $releaseDir 'Launch-Quality-Staff-Windows.zip')

Write-Host ""
Write-Host "Direct links:"
Write-Host "https://github.com/walednajjar2-salam/launch-quality-mobile/releases/download/$tag/Launch-Quality-Staff.apk"
Write-Host "https://github.com/walednajjar2-salam/launch-quality-mobile/releases/download/$tag/Launch-Quality-Staff-Windows.zip"
