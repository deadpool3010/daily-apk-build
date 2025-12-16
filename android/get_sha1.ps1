# PowerShell script to get SHA-1 fingerprint for Google Sign-In configuration
# Run this script and add the SHA-1 to Firebase Console

Write-Host "Getting SHA-1 fingerprint from debug keystore..." -ForegroundColor Cyan

$keystorePath = "$env:USERPROFILE\.android\debug.keystore"

if (Test-Path $keystorePath) {
    Write-Host "Found debug keystore at: $keystorePath" -ForegroundColor Green
    Write-Host ""
    Write-Host "SHA-1 Fingerprint:" -ForegroundColor Yellow
    keytool -list -v -keystore $keystorePath -alias androiddebugkey -storepass android -keypass android | Select-String -Pattern "SHA1:"
    Write-Host ""
    Write-Host "SHA-256 Fingerprint:" -ForegroundColor Yellow
    keytool -list -v -keystore $keystorePath -alias androiddebugkey -storepass android -keypass android | Select-String -Pattern "SHA256:"
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "1. Copy the SHA-1 fingerprint (the value after 'SHA1:')" -ForegroundColor White
    Write-Host "2. Go to Firebase Console: https://console.firebase.google.com/" -ForegroundColor White
    Write-Host "3. Select your project: bandhucare-493b0" -ForegroundColor White
    Write-Host "4. Go to Project Settings > Your apps > Android app (com.bandhucare.app)" -ForegroundColor White
    Write-Host "5. Click 'Add fingerprint' and paste the SHA-1 value" -ForegroundColor White
    Write-Host "6. Download the updated google-services.json file" -ForegroundColor White
    Write-Host "7. Replace the current google-services.json with the new one" -ForegroundColor White
} else {
    Write-Host "Debug keystore not found at: $keystorePath" -ForegroundColor Red
    Write-Host "This usually means you need to run a Flutter app first to generate it." -ForegroundColor Yellow
}

