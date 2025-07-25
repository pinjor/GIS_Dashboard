#!/bin/bash

# Usage: just run ./toggle_splash.sh
# Automatically toggles between first and second splash

set -e

echo "📄 Reading current splash image from pubspec.yaml..."

CURRENT_IMAGE_PATH=$(grep -m 1 'image: assets/images/.*_splash.png' pubspec.yaml | awk '{print $2}')

if [ "$CURRENT_IMAGE_PATH" == "assets/images/first_splash.png" ]; then
  TARGET_SPLASH="second"
  IMAGE_PATH="assets/images/second_splash.png"
elif [ "$CURRENT_IMAGE_PATH" == "assets/images/second_splash.png" ]; then
  TARGET_SPLASH="first"
  IMAGE_PATH="assets/images/first_splash.png"
else
  echo "❌ Could not determine current splash. Please ensure it's set to first or second splash in pubspec.yaml."
  exit 1
fi

echo "🔄 Toggling splash screen to: $TARGET_SPLASH"

# Check if the target image exists
if [ ! -f "$IMAGE_PATH" ]; then
  echo "❌ Error: Splash Image '$IMAGE_PATH' does not exist!"
  exit 1
fi

echo "✅ Splash Image '$IMAGE_PATH' found."

echo "🧹 Removing previous splash..."
flutter pub run flutter_native_splash:remove

# Cleaning the project
echo "🧼 Cleaning Flutter project..."
flutter clean
echo "📦 Fetching dependencies..."
flutter pub get

echo "🛠️  Updating pubspec.yaml to use $IMAGE_PATH..."

# Replace all splash paths in pubspec.yaml
sed -i "s|image: assets/images/.*_splash.png|image: $IMAGE_PATH|g" pubspec.yaml
sed -i "s|^\(\s*image:\s*\)assets/images/.*_splash.png|\1$IMAGE_PATH|g" pubspec.yaml

# For android_12 section
sed -i "s|^\(\s*android_12:\s*\n\s*color:\s*\"#FFFFFF\"\n\s*image:\s*\)assets/images/.*_splash.png|\1$IMAGE_PATH|g" pubspec.yaml

echo "📄 Updated pubspec.yaml with splash image: $IMAGE_PATH"

# Fetch again
flutter pub get

echo "🚀 Generating splash screen..."
flutter pub run flutter_native_splash:create

echo "🎯 Patching Android gravity=center → fill..."
sed -i 's/android:gravity="center"/android:gravity="fill"/g' android/app/src/main/res/drawable/launch_background.xml || true
sed -i 's/android:gravity="center"/android:gravity="fill"/g' android/app/src/main/res/drawable-v21/launch_background.xml || true

echo "✅ Done! Toggled splash screen to '${TARGET_SPLASH}_splash.png' successfully."