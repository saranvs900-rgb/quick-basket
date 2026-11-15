# Supabase Setup for Quick Basket

## 1. Create Supabase Project

1. Go to [https://supabase.com](https://supabase.com) and sign in
2. Click **New Project**
3. Choose organization, name it `quick-basket`, set a strong database password
4. Select a region close to your users (e.g. Mumbai / Singapore)
5. Wait for the project to be ready

## 2. Get API Keys

In Project Settings → API:

- **Project URL** → `SUPABASE_URL`
- **anon public** key → `SUPABASE_ANON_KEY`

You will put these in the Flutter apps.

## 3. Run Database Schema

1. Open **SQL Editor** in Supabase Dashboard
2. Copy the entire content of `supabase/schema.sql`
3. Paste and click **Run**

This creates all tables, indexes, and Row Level Security policies.

Optional: also run `supabase/seed.sql` for sample categories and products.

## 4. Enable Auth Providers

Go to **Authentication** → **Providers**:

- Enable **Phone** (you need an SMS provider like Twilio / MessageBird / or Supabase's built-in for testing)
- Enable **Email** (for Admin login)

For development you can also use the Email OTP / Magic Link.

## 5. Create Storage Buckets

Go to **Storage** → **New bucket**:

| Bucket name   | Public |
|---------------|--------|
| `products`    | Yes    |
| `banners`     | Yes    |
| `avatars`     | Yes    |

## 6. Create an Admin User

1. Go to Authentication → Users → Add user (email + password)
2. Copy the new user's UUID
3. In SQL Editor run:

```sql
UPDATE public.profiles
SET role = 'admin'
WHERE id = 'PASTE-USER-UUID-HERE';
```

Or insert if the trigger did not create the profile yet.

## 7. Configure Flutter Apps

In each app (`customer_app`, `delivery_app`, `admin_web`) create a file:

`lib/core/supabase_config.dart`

```dart
class SupabaseConfig {
  static const String url = 'https://YOUR_PROJECT_REF.supabase.co';
  static const String anonKey = 'YOUR_ANON_KEY';
}
```

**Never commit real keys to a public repo in production.** Prefer `--dart-define` or environment files.

## 8. Realtime (already enabled by default)

Order tracking uses Supabase Realtime on the `orders` table. No extra setup needed if Realtime is on (default).

## Done!

You can now run the Flutter apps. See `docs/INSTALLATION.md`.
