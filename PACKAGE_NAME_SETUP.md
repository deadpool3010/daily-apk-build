# Complete Package Name Setup Guide

## Step 1: Update Package Name in Android Configuration

### A. Update `android/app/build.gradle.kts`

✅ **COMPLETED** - Both `namespace` and `applicationId` have been updated to `com.bandhucare.newapp`

```kotlin
android {
    namespace = "com.bandhucare.newapp"  // ✅ Updated
    // ...
    defaultConfig {
        applicationId = "com.bandhucare.newapp"  // ✅ Updated
        // ...
    }
}
```

### B. Update MainActivity Package Declaration

✅ **COMPLETED** - MainActivity.kt has been moved to the new package directory:

- **Old location**: `android/app/src/main/kotlin/com/bandhucare/app/MainActivity.kt`
- **New location**: `android/app/src/main/kotlin/com/bandhucare/newapp/MainActivity.kt`

The package declaration has been updated to:
```kotlin
package com.bandhucare.newapp
```

### C. Update google-services.json

⚠️ **IMPORTANT**: The package name in `google-services.json` has been updated, but you need to:

1. **Create a NEW Android app in Firebase Console** with package name `com.bandhucare.newapp`
   - OR update the existing app's package name in Firebase
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Select project: **bandhucare-493b0**
   - Go to Project Settings → Your apps
   - Either:
     - **Option 1**: Add a new Android app with package name `com.bandhucare.newapp`
     - **Option 2**: Remove the old app and add new one with the new package name

2. **Add SHA-1 fingerprint** to the new app:
   - Get your SHA-1 fingerprint:
     ```powershell
     cd android
     .\get_sha1.ps1
     ```
   - Or manually:
     ```bash
     keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
     ```
   - Copy the SHA-1 value
   - Add it to Firebase Console → Your apps → Android app → Add fingerprint

3. **Download the new google-services.json**:
   - From Firebase Console → Project Settings → Your apps → Android app (`com.bandhucare.newapp`)
   - Download `google-services.json`
   - Replace `android/app/google-services.json` with the downloaded file

## Step 2: Clean and Rebuild

After updating all files:

```bash
cd bandhucare_new
flutter clean
flutter pub get
cd android
./gradlew clean
cd ..
flutter run
```

## Step 3: Verify Package Name Changes

Check that all references have been updated:

1. ✅ `android/app/build.gradle.kts` - `namespace` and `applicationId`
2. ✅ `android/app/src/main/kotlin/com/bandhucare/newapp/MainActivity.kt` - package declaration
3. ⚠️ `android/app/google-services.json` - package_name (download new from Firebase)
4. ✅ Directory structure matches new package name

## Step 4: Remove Old Package Directory (Optional)

After confirming everything works, you can delete the old package directory:

```bash
# Windows PowerShell
Remove-Item -Recurse -Force android\app\src\main\kotlin\com\bandhucare\app
```

## Important Notes

- ⚠️ **Firebase Setup Required**: You MUST create/update the Android app in Firebase Console with the new package name and download a fresh `google-services.json`
- ⚠️ **Google Sign-In**: After updating Firebase, make sure to add SHA-1 fingerprint for Google Sign-In to work
- ⚠️ **App Store**: If you're planning to publish, the package name change means this is a completely different app from the old one
- ⚠️ **Installation**: Users will need to uninstall the old app before installing the new one (due to different package names)

## Troubleshooting

### Error: "Package name mismatch"
- Make sure `google-services.json` has the correct package name
- Download a fresh `google-services.json` from Firebase Console

### Error: "MainActivity not found"
- Verify MainActivity.kt is in the correct directory: `android/app/src/main/kotlin/com/bandhucare/newapp/`
- Check that the package declaration matches the directory structure

### Google Sign-In still not working
- Ensure you've added SHA-1 fingerprint to Firebase Console
- Download the updated `google-services.json` after adding SHA-1
- Make sure `oauth_client` array in `google-services.json` contains an Android client (`client_type: 1`)


