#!/bin/bash

# FreshToday Release Build Script for Google Play Console
# This script builds signed release APK and AAB for Google Play Store

echo "🚀 Starting FreshToday Release Build Process..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    exit 1
fi

# Check if we're in the correct directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Not in a Flutter project directory"
    exit 1
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Generate app icons
echo "🎨 Generating app icons..."
flutter pub run flutter_launcher_icons:main

# Generate splash screen
echo "🖼️  Generating splash screen..."
flutter pub run flutter_native_splash:create

# Build release APK
echo "🔨 Building release APK..."
flutter build apk --release

# Build release AAB (Android App Bundle)
echo "📦 Building release AAB..."
flutter build appbundle --release

# Check if builds were successful
if [ $? -eq 0 ]; then
    echo "✅ Release builds completed successfully!"
    echo "📱 APK location: build/app/outputs/flutter-apk/app-release.apk"
    echo "📦 AAB location: build/app/outputs/bundle/release/app-release.aab"
    echo "📏 APK size: $(du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1)"
    echo "📏 AAB size: $(du -h build/app/outputs/bundle/release/app-release.aab | cut -f1)"
    
    # Create versioned copies
    VERSION=$(grep 'version:' pubspec.yaml | sed 's/version: //')
    cp build/app/outputs/flutter-apk/app-release.apk "FreshToday-v${VERSION}.apk"
    cp build/app/outputs/bundle/release/app-release.aab "FreshToday-v${VERSION}.aab"
    echo "📄 Versioned files created:"
    echo "   - FreshToday-v${VERSION}.apk"
    echo "   - FreshToday-v${VERSION}.aab"
    
    echo ""
    echo "🎉 Build completed successfully!"
    echo "📤 Upload the AAB file to Google Play Console"
    echo "🔗 Google Play Console: https://play.google.com/console"
    echo "📋 Note: Google Play Console requires AAB files for new app submissions"
else
    echo "❌ Build failed!"
    exit 1
fi 