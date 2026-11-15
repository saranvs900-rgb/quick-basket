# Deployment Guide (Supabase)

## Flutter Apps

Same as before:

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ipa --release

# Web Admin
flutter build web --release
```

Host the admin `build/web` folder on Vercel, Netlify, or any static host.

## Supabase

- Database and Auth are already hosted by Supabase
- For production:
  - Turn on **Email confirmations** if needed
  - Configure custom SMTP / SMS provider
  - Enable **Point-in-time recovery** on paid plans
  - Set up proper CORS and redirect URLs under Authentication → URL Configuration

## Environment variables

Never hard-code the anon key in production builds if the repo is public.
Use:

```bash
flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
```
