#!/bin/bash
SCHEME="Budget App"
PROJECT="Budget App.xcodeproj"
SIM_NAME="iPhone 17 Pro"

xcodebuild -project "$PROJECT" -scheme "$SCHEME" \
  -destination "platform=iOS Simulator,name=$SIM_NAME" build

APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "Budget App.app" -path "*iphonesimulator*" | head -n 1)

open -a Simulator
xcrun simctl install booted "$APP_PATH"
xcrun simctl launch booted $(defaults read "$APP_PATH/Info.plist" CFBundleIdentifier)