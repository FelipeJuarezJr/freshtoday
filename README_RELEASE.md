# FreshToday - Google Play Console Release Guide

This guide will help you build and deploy FreshToday to Google Play Console.

## Prerequisites

1. **Flutter SDK** - Make sure Flutter is installed and in your PATH
2. **Java JDK** - Required for Android builds and keystore creation
3. **Google Play Console Account** - Developer account with app created
4. **Firebase Project** - Configured with Authentication enabled

## Step 1: Create Keystore (First time only)

If this is your first release, you need to create a keystore file:

```bash
chmod +x create_keystore.sh
./create_keystore.sh
```

This will:
- Create a keystore file (`upload-keystore.jks`)
- Update `android/key.properties` with the correct paths
- Set up signing configuration

**⚠️ IMPORTANT**: Keep your keystore file safe! You'll need it for all future updates.

## Step 2: Update Version

Before building, update the version in `pubspec.yaml`:

```yaml
version: 1.0.0+4  # Increment the build number (+4)
```

## Step 3: Build Release APK

Run the automated build script:

```bash
chmod +x build_release.sh
./build_release.sh
```

This script will:
- Clean previous builds
- Get dependencies
- Generate app icons and splash screen
- Build signed release APK
- Create a versioned copy

## Step 4: Test the APK

Before uploading to Google Play Console, test the APK:

```bash
# Install on connected device
adb install build/app/outputs/flutter-apk/app-release.apk

# Or install the versioned APK
adb install FreshToday-v1.0.0+4.apk
```

## Step 5: Upload to Google Play Console

1. Go to [Google Play Console](https://play.google.com/console)
2. Select your FreshToday app
3. Go to "Release" → "Production" → "Create new release"
4. Upload the APK: `build/app/outputs/flutter-apk/app-release.apk`
5. Fill in release notes
6. Review and roll out

## Configuration Files

### android/key.properties
Contains keystore configuration for signing:
```
storePassword=your_keystore_password
keyPassword=your_key_password
keyAlias=your_key_alias
storeFile=path_to_your_keystore_file.jks
```

### android/app/build.gradle
Contains build configuration:
- Application ID: `com.freshtoday_app.app`
- Version code: 3
- Version name: "1.0.0"
- Signing configuration for release builds

## Troubleshooting

### Build Errors

1. **Keystore not found**: Run `./create_keystore.sh` first
2. **Permission denied**: Make scripts executable with `chmod +x *.sh`
3. **Flutter not found**: Ensure Flutter is in your PATH

### Google Play Console Issues

1. **APK rejected**: Check that all permissions are justified in the app description
2. **Version code conflict**: Increment version code in `build.gradle`
3. **Signing issues**: Ensure you're using the same keystore for updates

### Firebase Issues

1. **Authentication not working**: Ensure Firebase Authentication is enabled in Firebase Console
2. **Google Sign-In not working**: Add SHA-1 fingerprint to Firebase project

## Security Notes

- Never commit `upload-keystore.jks` to version control
- Keep keystore passwords secure
- Use different keystores for debug and release builds
- Backup your keystore file in a secure location

## Release Checklist

- [ ] Version updated in `pubspec.yaml`
- [ ] Version code incremented in `build.gradle`
- [ ] Keystore created and configured
- [ ] Release APK built successfully
- [ ] APK tested on device
- [ ] Release notes prepared
- [ ] Screenshots updated in Play Console
- [ ] App description and metadata updated
- [ ] Privacy policy URL added (if required)
- [ ] Content rating completed

## Support

If you encounter issues:
1. Check the build logs for specific error messages
2. Verify all prerequisites are installed
3. Ensure Firebase configuration is correct
4. Test with a debug build first

## Next Steps

After successful release:
1. Monitor crash reports in Google Play Console
2. Track user feedback and ratings
3. Plan feature updates and bug fixes
4. Prepare for the next release cycle 