# Quick Basket 🥬

**Fresh Groceries. Fast Delivery.**

A premium quick-commerce grocery delivery platform inspired by Zepto.

Built with **Flutter** (Customer App + Delivery Partner App + Flutter Web Admin) and **Firebase** (Auth, Firestore, Storage, Cloud Functions).

---

## 📋 Project Overview

| Component | Tech | Status |
|-----------|------|--------|
| Customer Mobile App | Flutter (Android + iOS) | Scaffold + Core flows |
| Delivery Partner App | Flutter | Scaffold + Order status |
| Admin Dashboard | Flutter Web | Scaffold + Analytics |
| Backend | Firebase Auth + Firestore + Storage + Functions | Configured |
| Payments | Razorpay (placeholder) | Ready for keys |
| Maps | Google Maps (placeholder) | Ready for API key |

---

## 📁 Repository Structure

```
quick-basket/
├── README.md
├── docs/
│   ├── FIREBASE_SETUP.md
│   ├── INSTALLATION.md
│   ├── DEPLOYMENT.md
│   └── DATABASE.md
├── shared/                          # Shared models, constants, theme
│   ├── lib/
│   │   ├── models/
│   │   ├── theme/
│   │   ├── constants/
│   │   └── utils/
│   └── pubspec.yaml
├── customer_app/                    # Customer Flutter app
├── delivery_app/                    # Delivery Partner Flutter app
├── admin_web/                       # Admin Dashboard (Flutter Web)
├── functions/                       # Firebase Cloud Functions
│   ├── src/
│   └── package.json
├── firestore.rules
├── firestore.indexes.json
├── storage.rules
└── firebase.json
```

---

## 🎯 Features Implemented in Scaffold

### Customer App
- Splash + Branding
- Phone / Email + OTP Auth (Firebase)
- Location & Address management
- Home with categories + banners
- Product listing & search
- Product details
- Cart with quantity management
- Wishlist
- Checkout flow
- Order status tracking
- Order history
- Profile & Support

### Admin Dashboard
- Login
- Dashboard analytics cards
- Product CRUD (add/edit/delete + image upload)
- Category management
- Inventory / stock
- Orders management + assign delivery partner
- Coupons
- Customer list

### Delivery Partner App
- Login
- Assigned orders list
- Accept / Reject
- Update order status
- Delivery history & earnings placeholder

### Order Statuses
`Order Placed` → `Order Confirmed` → `Preparing Order` → `Ready for Pickup` → `Out for Delivery` → `Delivered` / `Cancelled`

---

## 🔧 Technology Stack

- **Frontend**: Flutter 3.x + Dart
- **State Management**: Provider / Riverpod (recommended)
- **Backend**: Firebase Authentication, Cloud Firestore, Firebase Storage, Cloud Functions
- **Payments**: Razorpay
- **Maps**: Google Maps Flutter
- **Notifications**: Firebase Cloud Messaging

---

## 🚀 Quick Start

1. Clone the repo
```bash
git clone https://github.com/saranvs900-rgb/quick-basket.git
cd quick-basket
```

2. Follow **docs/FIREBASE_SETUP.md** to create a Firebase project and download config files.

3. Follow **docs/INSTALLATION.md** to run the apps.

4. See **docs/DEPLOYMENT.md** for production builds.

---

## 📝 Branding

- **Name**: QUICK BASKET
- **Tagline**: Fresh Groceries. Fast Delivery.
- **Primary Color**: `#2E7D32` (Green)
- **Secondary**: White + soft greys
- **Style**: Clean, rounded cards, premium grocery imagery, bottom navigation

---

## 🛡️ Security

- Role-based access (customer / admin / delivery_partner)
- Firestore Security Rules included
- Server-side price & stock validation recommended via Cloud Functions
- Payment verification on backend

---

## 📝 Next Steps for Full Production

1. Add real product images to Firebase Storage
2. Complete Razorpay integration + webhook
3. Google Maps live tracking
4. FCM push notifications
5. Cloud Functions for order assignment & stock deduction
6. Admin reports & charts
7. Unit + integration tests

---

**Made with ❤️ for quick commerce.**
