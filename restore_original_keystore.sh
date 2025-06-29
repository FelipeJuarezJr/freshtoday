#!/bin/bash

# FreshToday - Restore Original Keystore Script
# This script helps restore the original keystore that Google Play Console expects

echo "🔑 Restoring Original Keystore for Google Play Console"
echo ""
echo "Google Play Console expects SHA1: E8:E5:59:9A:FB:C0:40:25:A1:E7:28:A2:B6:51:D2:E5:96:75:32:70"
echo "Current keystore SHA1: 7B:ED:DD:5E:50:B5:B8:34:C3:C8:B2:92:81:C3:5A:1B:63:50:AC:F1"
echo ""

echo "📋 To restore the original keystore:"
echo "1. Locate your original keystore file (the one used for previous uploads)"
echo "2. Copy it to this directory as 'original-keystore.jks'"
echo "3. Run this script again"
echo ""

if [ -f "original-keystore.jks" ]; then
    echo "✅ Found original-keystore.jks"
    echo "🔍 Checking SHA1 fingerprint..."
    
    # Try to get SHA1 from the original keystore (user will need to provide password)
    echo "Please enter the keystore password for original-keystore.jks:"
    read -s keystore_password
    
    echo "Please enter the key alias (usually 'upload' or 'key0'):"
    read key_alias
    
    echo "Please enter the key password:"
    read -s key_password
    
    # Generate SHA1 from the original keystore
    keytool -list -v -keystore original-keystore.jks -alias "$key_alias" -storepass "$keystore_password" -keypass "$key_password" | grep "SHA1:"
    
    echo ""
    echo "📝 If the SHA1 matches E8:E5:59:9A:FB:C0:40:25:A1:E7:28:A2:B6:51:D2:E5:96:75:32:70,"
    echo "   we can update the configuration to use this keystore."
    echo ""
    echo "Would you like to update the configuration? (y/n):"
    read update_config
    
    if [ "$update_config" = "y" ] || [ "$update_config" = "Y" ]; then
        # Backup current keystore
        cp upload-keystore.jks upload-keystore.jks.backup
        
        # Replace with original keystore
        cp original-keystore.jks upload-keystore.jks
        
        # Update key.properties
        cat > android/key.properties << EOF
storePassword=$keystore_password
keyPassword=$key_password
keyAlias=$key_alias
storeFile=../../upload-keystore.jks
EOF
        
        echo "✅ Configuration updated!"
        echo "🔄 Now rebuild the app with: ./build_release.sh"
    fi
else
    echo "❌ original-keystore.jks not found"
    echo ""
    echo "📁 Common locations to check:"
    echo "   - Android Studio projects"
    echo "   - Previous Flutter projects"
    echo "   - Backup folders"
    echo "   - Google Drive/Dropbox"
    echo ""
    echo "🔍 Search for files with these extensions:"
    echo "   - .jks (Java KeyStore)"
    echo "   - .keystore"
    echo "   - .p12 (PKCS12)"
fi 