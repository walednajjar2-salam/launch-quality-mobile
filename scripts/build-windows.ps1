# Build Windows release
$ErrorActionPreference = "Stop"
$env:Path = "C:\Users\waled\flutter\bin;" + $env:Path

Set-Location (Split-Path $PSScriptRoot -Parent)

flutter pub get
flutter config --enable-windows-desktop
flutter build windows --release

$out = "build\windows\x64\runner\Release"
if (Test-Path $out) {
  Write-Host "Windows build: $((Resolve-Path $out).Path)" -ForegroundColor Green
}
