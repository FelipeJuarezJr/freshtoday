# Creating a New App in Google Play Console

If you cannot find the original keystore, you can create a new app in Google Play Console.

## 🔄 Option: Create New App

### Step 1: Create New App in Google Play Console
1. Go to [Google Play Console](https://play.google.com/console)
2. Click "Create app"
3. Choose "Create new app"
4. Fill in the app details:
   - **App name**: FreshToday (or FreshToday Pro, FreshToday Plus, etc.)
   - **Default language**: English
   - **App or game**: App
   - **Free or paid**: Free

### Step 2: Use Current Keystore
Your current keystore (SHA1: `7B:ED:DD:5E:50:B5:B8:34:C3:C8:B2:92:81:C3:5A:1B:63:50:AC:F1`) will work perfectly for the new app.

### Step 3: Update Package Name (Optional)
If you want to keep the same app name, you can update the package name:

1. Update `android/app/build.gradle`:
```gradle
applicationId "com.freshtoday_app.app_v2"  // or any unique name
```

2. Update `android/app/src/main/kotlin/com/freshtoday_app/app/MainActivity.kt`:
```kotlin
package com.freshtoday_app.app_v2  // match the applicationId
```

3. Update Firebase configuration with the new package name

### Step 4: Rebuild and Upload
```bash
./build_release.sh
```

Then upload the new AAB to the new app in Google Play Console.

## ⚠️ Important Considerations

### Pros of New App:
- ✅ No keystore issues
- ✅ Fresh start
- ✅ Can use current keystore

### Cons of New App:
- ❌ Lose previous app history
- ❌ Lose previous ratings/reviews
- ❌ Users need to reinstall
- ❌ Different app URL

## 🔍 Finding the Original Keystore

Before creating a new app, try to find the original keystore:

### Common Locations:
- **Android Studio**: `~/.android/debug.keystore` or project-specific keystores
- **Previous projects**: Check other Flutter/Android projects
- **Backup folders**: Google Drive, Dropbox, local backups
- **Development machine**: Check all `.jks`, `.keystore`, `.p12` files

### Search Commands:
```bash
# Search for keystore files
find ~ -name "*.jks" -o -name "*.keystore" -o -name "*.p12" 2>/dev/null

# Search in common Android locations
find ~/.android -name "*.jks" -o -name "*.keystore" 2>/dev/null
```

## 🎯 Recommendation

1. **First**: Try to find the original keystore using the search commands above
2. **If found**: Use the `restore_original_keystore.sh` script
3. **If not found**: Create a new app with a slightly different name (e.g., "FreshToday Pro")

## 📞 Next Steps

1. Search for the original keystore
2. If found, run: `chmod +x restore_original_keystore.sh && ./restore_original_keystore.sh`
3. If not found, create a new app in Google Play Console
4. Rebuild and upload the AAB file 