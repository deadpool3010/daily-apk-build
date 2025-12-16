# Google Sign-In Setup Guide

## Error: "[28444] Developer console is not set up correctly"

This error occurs because the Android OAuth client is not configured in Firebase Console.

## Solution Steps

### 1. Get Your SHA-1 Fingerprint

**Option A: Using the provided script (Windows PowerShell)**
```powershell
cd android
.\get_sha1.ps1
```

**Option B: Manual command**
```bash
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

Copy the **SHA-1** fingerprint value (it looks like: `AB:CD:EF:12:34:56:...`)

### 2. Add SHA-1 to Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **bandhucare-493b0**
3. Click the gear icon ⚙️ → **Project Settings**
4. Scroll down to **Your apps** section
5. Find your Android app with package name: `com.bandhucare.app`
6. Click **Add fingerprint**
7. Paste your SHA-1 fingerprint
8. Click **Save**

### 3. Download Updated google-services.json

1. Still in Firebase Console → Project Settings
2. In the **Your apps** section, find your Android app
3. Click the **google-services.json** download button
4. Replace the existing file at: `android/app/google-services.json`

### 4. Verify the Configuration

After downloading the new `google-services.json`, check that it contains OAuth client information:

Open `android/app/google-services.json` and verify that the `oauth_client` array is no longer empty:

```json
"oauth_client": [
  {
    "client_id": "YOUR_ANDROID_CLIENT_ID.apps.googleusercontent.com",
    "client_type": 1,
    "android_info": {
      "package_name": "com.bandhucare.app",
      "certificate_hash": "YOUR_SHA1_FINGERPRINT"
    }
  },
  {
    "client_id": "725022291318-0fp1u3c0rcdfe96ma7s86dldbboraf8a.apps.googleusercontent.com",
    "client_type": 3
  }
]
```

### 5. Rebuild Your App

```bash
flutter clean
flutter pub get
flutter run
```

## For Release Builds

When you're ready to release, you'll also need to:
1. Get the SHA-1 from your **release keystore**
2. Add it to Firebase Console (same steps as above)
3. Download the updated `google-services.json` again

## Troubleshooting

- **Error persists?** Make sure you downloaded the updated `google-services.json` after adding the SHA-1
- **Still not working?** Verify your package name matches: `com.bandhucare.app`
- **Need production SHA-1?** Generate it from your release keystore, not the debug keystore

