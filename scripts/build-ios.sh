#!/bin/bash
set -e

VERSION=$(grep '^version:' pubspec.yaml | cut -d' ' -f2)

echo "🍎 =========================================="
echo "🍎 Building Launch Quality iOS App v${VERSION}"
echo "🍎 =========================================="

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}1️⃣  Cleaning project...${NC}"
flutter clean
rm -rf ios/Pods ios/Podfile.lock

echo -e "${BLUE}2️⃣  Getting dependencies...${NC}"
flutter pub get

echo -e "${BLUE}3️⃣  Installing CocoaPods...${NC}"
cd ios
pod install --repo-update
cd ..

echo -e "${BLUE}4️⃣  Building iOS release...${NC}"
flutter build ios --release

echo -e "${GREEN}✅ Build complete! Version ${VERSION}${NC}"
echo ""
echo "📋 Next: Open ios/Runner.xcworkspace in Xcode"
