$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot -Parent
$releaseDir = Join-Path $repo 'release'
$winSrc = Join-Path $repo 'build\windows\x64\runner\Release'
$zipOut = Join-Path $releaseDir 'Launch-Quality-Staff-Windows.zip'

if (-not (Test-Path $winSrc)) {
  throw "Windows build not found at $winSrc. Run: flutter build windows --release"
}

New-Item -ItemType Directory -Force -Path $releaseDir | Out-Null
if (Test-Path $zipOut) { Remove-Item $zipOut -Force }

Compress-Archive -Path (Join-Path $winSrc '*') -DestinationPath $zipOut -Force
Write-Host "Created: $zipOut"
