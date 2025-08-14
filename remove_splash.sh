#!/bin/bash

# Usage: ./remove_splash.sh
# Safely removes the current splash screen using flutter_native_splash

set -e

echo "🧹 Removing splash screen..."
flutter pub run flutter_native_splash:remove

echo "✅ Splash screen removed."

# Cleaning the project
echo "🧼 Cleaning Flutter project..."
flutter clean
echo "📦 Fetching dependencies..."
flutter pub get

echo "✅ Done! Removed splash screen successfully."
