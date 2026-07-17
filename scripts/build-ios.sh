#!/usr/bin/env bash
# Build iOS release (requires macOS + Xcode + CocoaPods).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "iOS builds require macOS with Xcode." >&2
  exit 1
fi

flutter pub get
cd ios
pod install
cd ..

flutter build ios --release --no-codesign

echo ""
echo "iOS release build ready under: build/ios/iphoneos/"
echo "Open ios/Runner.xcworkspace in Xcode to archive & sign for a device or TestFlight."
