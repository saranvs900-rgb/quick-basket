# Deployment Guide

## Android (Customer / Delivery)

```bash
cd customer_app   # or delivery_app
flutter build apk --release
# or
flutter build appbundle --release
```

Upload the AAB to Google Play Console.

## iOS

```bash
flutter build ipa --release
```

Upload via Xcode or Transporter to App Store Connect.

## Admin Web (Flutter Web)

```bash
cd admin_web
flutter build web --release
```

Deploy to Firebase Hosting:

```bash
firebase init hosting   # point to admin_web/build/web
firebase deploy --only hosting
```

## Cloud Functions

```bash
cd functions
npm install
firebase deploy --only functions
```

## Important Production Checklist

- [ ] Replace all test keys (Razorpay, Maps, etc.)
- [ ] Enable App Check
- [ ] Review and tighten Firestore rules
- [ ] Set up proper CORS if needed
- [ ] Configure custom domain for admin
- [ ] Enable Crashlytics & Analytics
- [ ] Set up CI/CD (GitHub Actions recommended)
