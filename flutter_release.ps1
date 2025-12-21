Write-Host "🧹 Cleaning..."
flutter clean

Write-Host "📦 Getting packages..."
flutter pub get

Write-Host "📦 Building release APK..."
flutter build apk --release