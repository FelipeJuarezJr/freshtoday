#!/bin/bash

# FreshToday Keystore Creation Script
# This script creates a keystore file for signing your APK

echo "🔑 Creating keystore for FreshToday..."

# Check if keytool is available
if ! command -v keytool &> /dev/null; then
    echo "❌ keytool is not installed. Please install Java JDK."
    exit 1
fi

# Set keystore details
KEYSTORE_FILE="upload-keystore.jks"
KEY_ALIAS="upload"
KEY_PASSWORD="freshtoday"
STORE_PASSWORD="freshtoday"

echo "📝 Keystore Details:"
echo "   File: $KEYSTORE_FILE"
echo "   Alias: $KEY_ALIAS"
echo "   Key Password: $KEY_PASSWORD"
echo "   Store Password: $STORE_PASSWORD"

# Create keystore
keytool -genkey -v -keystore $KEYSTORE_FILE -keyalg RSA -keysize 2048 -validity 10000 -alias $KEY_ALIAS -storepass $STORE_PASSWORD -keypass $KEY_PASSWORD -dname "CN=FreshToday, OU=Development, O=FreshToday, L=City, S=State, C=US"

if [ $? -eq 0 ]; then
    echo "✅ Keystore created successfully!"
    echo "📁 Keystore location: $(pwd)/$KEYSTORE_FILE"
    
    # Update key.properties file
    cat > android/key.properties << EOF
storePassword=$STORE_PASSWORD
keyPassword=$KEY_PASSWORD
keyAlias=$KEY_ALIAS
storeFile=../$KEYSTORE_FILE
EOF
    
    echo "✅ key.properties updated!"
    echo ""
    echo "🔐 IMPORTANT: Keep your keystore file safe!"
    echo "   - Store it in a secure location"
    echo "   - Make a backup"
    echo "   - You'll need it for all future app updates"
    echo ""
    echo "📱 You can now run: ./build_release.sh"
else
    echo "❌ Failed to create keystore!"
    exit 1
fi 