#!/usr/bin/env bash
#
# Build the optimized Release app.
# Usage: ./scripts/build-release.sh
#
# Result: build/Build/Products/Release/spriteTest.app
#
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

DERIVED="$PROJECT_DIR/build"

echo "==> Building (Release)..."
xcodebuild -project spriteTest.xcodeproj \
           -scheme spriteTest \
           -configuration Release \
           -derivedDataPath "$DERIVED" \
           clean build

APP="$DERIVED/Build/Products/Release/spriteTest.app"

echo
echo "==> Done. App built at:"
echo "    $APP"
echo
echo "    Run it with:        open \"$APP\""
echo "    Install it with:    cp -R \"$APP\" /Applications/"
