# Installation & Running Quick Basket (Supabase)

## Prerequisites

- Flutter SDK 3.22+
- A Supabase project (see SUPABASE_SETUP.md)
- Android Studio / Xcode / Chrome

## 1. Clone

```bash
git clone https://github.com/saranvs900-rgb/quick-basket.git
cd quick-basket
```

## 2. Configure Supabase keys

Create / edit in each app:

```dart
// lib/core/supabase_config.dart
class SupabaseConfig {
  static const String url = 'https://xxxxx.supabase.co';
  static const String anonKey = 'eyJhbGciOiJI...';
}
```

## 3. Install packages & run

### Customer App
```bash
cd customer_app
flutter pub get
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

## 4. First Admin login

- Create a user in Supabase Auth (email + password)
- Set `role = 'admin'` in the `profiles` table
- Login from the Admin Web dashboard

## Troubleshooting

- **Auth errors**: Check Phone provider is enabled and SMS is configured
- **RLS policy errors**: Make sure you ran the full `schema.sql`
- **Empty products**: Run `seed.sql` or add products from Admin
