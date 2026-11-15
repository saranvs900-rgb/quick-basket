# Quick Basket 🥬

**Fresh Groceries. Fast Delivery.**

A premium quick-commerce grocery delivery platform inspired by Zepto.

**Backend: Supabase** (Auth + PostgreSQL + Storage + Realtime + Edge Functions)

Built with **Flutter** (Customer App + Delivery Partner App + Flutter Web Admin).

---

## 📋 Project Overview

| Component | Tech | Status |
|-----------|------|--------|
| Customer Mobile App | Flutter (Android + iOS) | Scaffold + Core flows |
| Delivery Partner App | Flutter | Scaffold + Order status |
| Admin Dashboard | Flutter Web | Scaffold + Analytics |
| Backend | **Supabase** (Auth, Postgres, Storage, Realtime) | Configured |
| Payments | Razorpay (placeholder) | Ready for keys |
| Maps | Google Maps (placeholder) | Ready for API key |

---

## 📁 Repository Structure

```
quick-basket/
├── README.md
├── docs/
│   ├── SUPABASE_SETUP.md
│   ├── INSTALLATION.md
│   ├── DEPLOYMENT.md
│   └── DATABASE.md
├── supabase/
│   ├── schema.sql          # Full database schema + RLS
│   └── seed.sql            # Optional sample data
├── shared/
├── customer_app/
├── delivery_app/
└── admin_web/
```

---

## 🎯 Features

### Customer App
- Splash + Branding
- Phone / Email + OTP Auth (Supabase Auth)
- Home with categories + banners
- Product listing, search & details
- Cart with quantity management
- Checkout + Order placement
- Live order status tracking (Realtime)
- Order history & Profile

### Admin Dashboard
- Login (role-based)
- Dashboard analytics
- Product CRUD
- Order management + assign delivery partner

### Delivery Partner App
- Login
- Assigned orders
- Update order status

### Order Statuses
`Order Placed` → `Order Confirmed` → `Preparing Order` → `Ready for Pickup` → `Out for Delivery` → `Delivered` / `Cancelled`

---

## 🔧 Technology Stack

- **Frontend**: Flutter 3.x + Dart
- **State Management**: Provider
- **Backend**: **Supabase**
  - Auth (Phone OTP + Email)
  - PostgreSQL database
  - Row Level Security (RLS)
  - Storage (product images)
  - Realtime subscriptions
- **Payments**: Razorpay
- **Maps**: Google Maps Flutter

---

## 🚀 Quick Start

1. Clone the repo
```bash
git clone https://github.com/saranvs900-rgb/quick-basket.git
cd quick-basket
```

2. Follow **docs/SUPABASE_SETUP.md** to create a Supabase project and run the schema.

3. Follow **docs/INSTALLATION.md** to run the apps.

---

## 📝 Branding

- **Name**: QUICK BASKET
- **Tagline**: Fresh Groceries. Fast Delivery.
- **Primary Color**: `#2E7D32` (Green)

---

**Backend migrated from Firebase → Supabase.**
