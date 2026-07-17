#!/bin/bash
set -e

echo "🍎 Building iOS app..."

flutter clean
flutter pub get

cd ios
pod install --repo-update
cd ..

flutter build ios --release

echo "✅ iOS build complete!"
echo "📱 Next: Open ios/Runner.xcworkspace in Xcode"
echo "📦 Archive → Validate → Upload to TestFlight"
