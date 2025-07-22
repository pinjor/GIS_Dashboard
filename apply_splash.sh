#!/bin/bash

# Usage:
# ./apply_splash.sh first
# ./apply_splash.sh second

set -e

SPLASH_NAME=$1

if [ -z "$SPLASH_NAME" ]; then
  echo "❌ Please specify which splash to generate: 'first' or 'second'"
  exit 1
fi

# Define path based on input
if [ "$SPLASH_NAME" == "first" ]; then
  IMAGE_PATH="assets/first_splash.png"
elif [ "$SPLASH_NAME" == "second" ]; then
  IMAGE_PATH="assets/second_splash.png"
else
  echo "❌ Invalid argument: use 'first' or 'second'"
  exit 1
fi

# check if the image exists
echo "🔍 Checking if splash image exists"

if [ ! -f "$IMAGE_PATH" ]; then
  echo "❌ Error: Splash Image '$IMAGE_PATH' does not exist!"
  exit 1
fi

echo "✅ Splash Image '$IMAGE_PATH' found."


echo "📄 Checking current splash image in pubspec.yaml..."
# Extract the current image path from pubspec.yaml (first match only)
CURRENT_IMAGE_PATH=$(grep -m 1 'image: assets/.*_splash.png' pubspec.yaml | awk '{print $2}')

if [ "$CURRENT_IMAGE_PATH" == "$IMAGE_PATH" ]; then
  echo "✅ Splash already set to '$SPLASH_NAME' — skipping generation."
  exit 1
fi



echo "🧹 Removing previous splash..."
flutter pub run flutter_native_splash:remove

# cleaning the project
echo "🧼 Cleaning Flutter project..."
flutter clean
echo "📦 Fetching dependencies..."
flutter pub get


echo "🛠️  Updating pubspec.yaml to use $IMAGE_PATH..."

# Edit pubspec.yaml splash image path
# Make sure your yaml line starts exactly like: image: assets/images/...
sed -i "s|image: assets/.*_splash.png|image: $IMAGE_PATH|g" pubspec.yaml
sed -i "s|^\(\s*image:\s*\)assets/.*_splash.png|\1$IMAGE_PATH|g" pubspec.yaml

# Same for android_12 section
sed -i "s|^\(\s*android_12:\s*\n\s*color:\s*\"#FFFFFF\"\n\s*image:\s*\)assets/.*_splash.png|\1$IMAGE_PATH|g" pubspec.yaml

echo "📄 Updated pubspec.yaml with splash image: $IMAGE_PATH"

# getting package config
echo "📦 Fetching dependencies..."
flutter pub get

echo "🚀 Generating splash screen..."
flutter pub run flutter_native_splash:create

echo "🎯 Patching Android gravity=center → fill..."
sed -i 's/android:gravity="center"/android:gravity="fill"/g' android/app/src/main/res/drawable/launch_background.xml || true
sed -i 's/android:gravity="center"/android:gravity="fill"/g' android/app/src/main/res/drawable-v21/launch_background.xml || true

echo "✅ Done! Generated splash for '${SPLASH_NAME}_splash.png' successfully."
