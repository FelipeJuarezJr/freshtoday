#!/bin/bash

# FreshToday - Install Debug APK Script
# This script installs the debug APK for testing authentication issues

echo "📱 Installing FreshToday Debug APK..."

# Check if adb is available
if ! command -v adb &> /dev/null; then
    echo "❌ adb is not installed or not in PATH"
    echo "Please install Android SDK Platform Tools"
    exit 1
fi

# Check if device is connected
echo "🔍 Checking for connected devices..."
adb devices

# Check if debug APK exists
if [ ! -f "build/app/outputs/flutter-apk/app-debug.apk" ]; then
    echo "❌ Debug APK not found. Building it first..."
    flutter build apk --debug
fi

# Install the debug APK
echo "📦 Installing debug APK..."
adb install -r build/app/outputs/flutter-apk/app-debug.apk

if [ $? -eq 0 ]; then
    echo "✅ Debug APK installed successfully!"
    echo ""
    echo "📋 Instructions:"
    echo "1. Open the FreshToday app on your phone"
    echo "2. You should see a 'Debug Info' screen"
    echo "3. Check the authentication state information"
    echo "4. Try the 'Go to Login Screen' button"
    echo "5. Try logging in and see what happens"
    echo "6. Check the 'Firebase State' section"
    echo ""
    echo "🔍 To view logs:"
    echo "adb logcat | grep -E '(FreshToday|AuthProvider|Firebase)'"
else
    echo "❌ Failed to install debug APK"
    exit 1
fi 