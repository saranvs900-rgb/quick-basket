# Installation & Running Quick Basket

## Prerequisites

- Flutter SDK 3.22+ (stable)
- Dart SDK
- Android Studio / Xcode
- Node.js 18+ (for Cloud Functions)
- Firebase CLI (`npm i -g firebase-tools`)
- A Firebase project (see FIREBASE_SETUP.md)

## 1. Clone & Get Packages

```bash
git clone https://github.com/saranvs900-rgb/quick-basket.git
cd quick-basket
```

### Shared package
```bash
cd shared
flutter pub get
cd ..
```

### Customer App
```bash
cd customer_app
flutter pub get
# After flutterfire configure
flutter run
```

### Delivery App
```bash
cd delivery_app
flutter pub get
flutter run
```

### Admin Web
```bash
cd admin_web
flutter pub get
flutter run -d chrome
```

## 2. Firebase Configuration

After placing `google-services.json` / `GoogleService-Info.plist` and running `flutterfire configure`:

Make sure `lib/firebase_options.dart` exists in each app.

## 3. Google Maps (optional for now)

Add your Maps API key:

**Android** → `android/app/src/main/AndroidManifest.xml`
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_MAPS_KEY"/>
```

**iOS** → `ios/Runner/AppDelegate.swift` + Info.plist

## 4. Razorpay

Add test keys in a secure place (never hardcode in production):

```dart
// Example
const razorpayKeyId = String.fromEnvironment('RAZORPAY_KEY');
```

## 5. Run on Emulator / Device

```bash
flutter devices
flutter run -d <device-id>
```

For web admin:
```bash
flutter run -d chrome --web-port=5000
```

## Troubleshooting

- **MissingPluginException**: Run `flutter clean && flutter pub get`
- **Firebase not initialized**: Check `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`
- **Phone Auth on Android**: Add SHA-1 / SHA-256 in Firebase Console
