#!/bin/bash

# FreshToday - SHA-1 Fingerprint Generator
# This script generates the SHA-1 fingerprint needed for Firebase configuration

echo "🔑 Generating SHA-1 fingerprint for Firebase configuration..."

# Check if keytool is available
if ! command -v keytool &> /dev/null; then
    echo "❌ keytool is not installed or not in PATH"
    echo "Please install Java JDK to get keytool"
    exit 1
fi

# Generate SHA-1 from the keystore
echo "📱 Generating SHA-1 from release keystore..."
keytool -list -v -keystore upload-keystore.jks -alias upload -storepass freshtoday -keypass freshtoday | grep "SHA1:"

echo ""
echo "📋 Copy the SHA-1 fingerprint above and add it to your Firebase project:"
echo "1. Go to Firebase Console: https://console.firebase.google.com"
echo "2. Select your FreshToday project"
echo "3. Go to Project Settings → Your apps → Android app"
echo "4. Click 'Add fingerprint' and paste the SHA-1 value"
echo ""
echo "🔗 Firebase Console: https://console.firebase.google.com"
echo ""
echo "✅ Expected SHA-1: E8:E5:59:9A:FB:C0:40:25:A1:E7:28:A2:B6:51:D2:E5:96:75:32:70" 