#!/usr/bin/env bash
#
# Build the Debug configuration and launch the app.
# Usage: ./scripts/run-debug.sh
#
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

DERIVED="$PROJECT_DIR/build"

echo "==> Building (Debug)..."
xcodebuild -project spriteTest.xcodeproj \
           -scheme spriteTest \
           -configuration Debug \
           -derivedDataPath "$DERIVED" \
           build

APP="$DERIVED/Build/Products/Debug/spriteTest.app"

echo "==> Launching: $APP"
echo "    (The window is full-screen; press ESC to quit.)"
open "$APP"
