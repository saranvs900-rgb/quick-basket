# Firebase Setup for Quick Basket

## 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project named **Quick Basket**
3. Enable **Google Analytics** (optional)

## 2. Enable Services

### Authentication
- Sign-in method → **Phone** (enable)
- Sign-in method → **Email/Password** (enable)

### Cloud Firestore
- Create database in **production mode** (we will apply rules later)
- Start in a location close to your users (e.g. `asia-south1`)

### Storage
- Enable Firebase Storage

### Cloud Functions
- Upgrade to **Blaze** plan (required for Functions + external APIs)

### Cloud Messaging
- Enable for push notifications

## 3. Register Apps

### Android (Customer + Delivery)
- Package name examples:
  - Customer: `com.quickbasket.customer`
  - Delivery: `com.quickbasket.delivery`
- Download `google-services.json` and place in:
  - `customer_app/android/app/`
  - `delivery_app/android/app/`

### iOS
- Bundle IDs: `com.quickbasket.customer` / `com.quickbasket.delivery`
- Download `GoogleService-Info.plist` → `ios/Runner/`

### Web (Admin)
- Register a Web app
- Copy the Firebase config object

## 4. Download Config Files

Place the generated files as instructed above.  
For FlutterFire CLI (recommended):

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Run this inside each app folder (`customer_app`, `delivery_app`, `admin_web`).

## 5. Deploy Rules & Indexes

From the root of the monorepo:

```bash
firebase login
firebase use --add   # select your project
firebase deploy --only firestore:rules,firestore:indexes,storage
```

## 6. Environment Variables / Secrets

Never commit real API keys.

Recommended approach:
- Use `--dart-define` or a `.env` + `flutter_dotenv`
- For Cloud Functions: Firebase Functions config or Secret Manager

```bash
# Example
firebase functions:config:set razorpay.key_id="rzp_test_xxx" razorpay.key_secret="xxx"
```

## 7. Collections to Create Manually (optional seed)

You can seed from Admin panel or use the Firebase Console:

- `categories`
- `products`
- `users`
- `orders`
- `delivery_partners`
- `coupons`
- `addresses`
- `carts`
- `payments`
- `assignments`

See `docs/DATABASE.md` for full schema.
