#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "==> Sync Capacitor"
npm install
npx cap sync android

echo "==> Build release APK (requires Android SDK + JAVA_HOME)"
cd android
./gradlew assembleRelease

APK="app/build/outputs/apk/release/Launch-Quality-Staff.apk"
if [[ -f "$APK" ]]; then
  echo "Built: android/$APK"
else
  echo "Release APK not found. Check android/app/build/outputs/apk/release/"
  ls -la app/build/outputs/apk/release/ 2>/dev/null || true
fi
