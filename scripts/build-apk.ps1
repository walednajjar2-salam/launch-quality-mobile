# Build release APK after Android SDK is installed
$ErrorActionPreference = "Stop"
$env:Path = "C:\Users\waled\flutter\bin;" + $env:Path

$sdk = "$env:LOCALAPPDATA\Android\Sdk"
if (-not (Test-Path $sdk)) {
  Write-Host "Android SDK not found. Open Android Studio once and install SDK, or set ANDROID_HOME." -ForegroundColor Yellow
  exit 1
}

$env:ANDROID_HOME = $sdk
Set-Location (Split-Path $PSScriptRoot -Parent)

flutter pub get
flutter build apk --release

$apk = "build\app\outputs\flutter-apk\app-release.apk"
if (Test-Path $apk) {
  $dest = "$env:USERPROFILE\OneDrive\Desktop\Launch-Quality-Staff.apk"
  Copy-Item $apk $dest -Force
  Write-Host "APK copied to: $dest" -ForegroundColor Green
}
