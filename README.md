<div align="center">

# 🚂 Amar Rail Sheba
### Bangladesh Railway Ticket Booking System

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Realtime_DB-FFCA28?logo=firebase)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-Academic-blue)](#license)

**Live Web App →** [Firebase](https://railwaysystems-7d372.web.app) · [Vercel](https://amar-rail-sheba.vercel.app)

> 📚 Academic Project — DBMS Course, Group 05, United International University

</div>

---

## 📱 Screenshots

> _Add screenshots here_

---

## ✨ Features

| Feature | Details |
|---|---|
| 🔐 **Auth** | Firebase login / register / forgot password |
| 🔍 **Train Search** | Route, date, class, passenger count (1–4) |
| 🗺️ **60+ Stations** | All 8 divisions of Bangladesh |
| 💺 **Seat Selection** | Interactive coach map — enforces exact passenger count |
| 🎫 **Digital Tickets** | PDF download, monthly grouped in My Tickets |
| � **Weekly Limit** | Max 4 tickets per user per week |
| �📍 **Live Tracking** | Real-time train location on Google Maps |
| 🔔 **Push Notifications** | Firebase Cloud Messaging |
| 🧳 **Lost & Found** | Report + claim system |
| 🚨 **Emergency Contacts** | Quick access to railway emergency numbers |
| ⭐ **Ratings & Reviews** | Per-train reviews |
| 🛡️ **Admin Panel** | Trains, bookings, users, announcements |
| 📱 **Responsive** | Phone, tablet, web |

---

## 🌐 Live Links

| Platform | URL |
|---|---|
| 🔥 Firebase Hosting | https://railwaysystems-7d372.web.app |
| ▲ Vercel | https://amar-rail-sheba.vercel.app |

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x (Dart) |
| State Management | GetX |
| Auth & Database | Firebase Auth + Realtime Database |
| Maps | Google Maps Flutter |
| Location | Geolocator |
| Local Storage | SharedPreferences |
| PDF Generation | pdf + printing |
| QR Code | qr_flutter |
| Crash Reporting | Firebase Crashlytics |
| Analytics | Firebase Analytics |
| Push Notifications | Firebase Cloud Messaging |

---

## 🚀 Quick Start

```bash
git clone https://github.com/AhnafwadudArnab/Amar-Rail-sheba.git
cd Amar-Rail-sheba
flutter pub get
```

1. Download `google-services.json` from Firebase Console → place at `android/app/`
2. Add your Google Maps API key in `android/app/src/main/AndroidManifest.xml`
3. `flutter run`

**Firebase project:** `railwaysystems-7d372`  
**DB URL:** `https://railwaysystems-7d372-default-rtdb.asia-southeast1.firebasedatabase.app`

---

## 📦 Build & Deploy

### Android APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Web → Firebase
```bash
flutter build web --release
firebase deploy --only hosting
```

### Web → Vercel
```bash
vercel deploy --prod
# Auto-deploys on every push to main branch
```

---

## 🎫 Booking Flow

```
Search Train → Select Seats → Payment → Ticket Generated → Saved to My Tickets
```

- **Seat limit** — exactly matches passenger count selected at search
- **Weekly limit** — max 4 tickets per user per week (Mon–Sun)
- **Seat locking** — Firebase transaction locks seats for 10 minutes during payment
- **Payment** — direct booking confirmation (SSLCommerz integration ready for production)

---

## 📄 My Tickets

- Tickets grouped by **month** (e.g. April 2026, March 2026)
- Each ticket shows: route, date, seat(s), class, amount, status
- **Download as PDF** — web triggers browser download, mobile opens share dialog
- Tap any ticket to view full ticket detail with barcode

---

## � Train Routes & Names

| Route | Trains |
|---|---|
| Dhaka ↔ Chattogram | Subarna Express, Sonar Bangla Express, Mahanagar Provati, Turna Nishitha |
| Dhaka ↔ Sylhet | Parabat Express, Jayantika Express, Upaban Express, Kalni Express |
| Dhaka ↔ Rajshahi | Silk City Express, Padma Express, Dhumketu Express |
| Dhaka ↔ Khulna | Sundarban Express, Chitra Express |
| Dhaka ↔ Rangpur | Rangpur Express, Kurigram Express |
| Dhaka ↔ Dinajpur | Ekota Express, Drutojan Express |
| Chattogram ↔ Sylhet | Paharika Express, Udayan Express |

---

## �🔐 Firebase Security Rules

Apply in Firebase Console → Realtime Database → Rules:

```json
{
  "rules": {
    ".read": "auth != null",
    ".write": "auth != null",
    "bookings": {
      ".indexOn": ["userId"]
    },
    "users": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid"
      }
    },
    "lostFound":    { ".read": true, ".write": "auth != null" },
    "liveLocation": { ".read": true, ".write": "auth.token.admin === true" },
    "reviews":      { ".read": true, ".write": "auth != null" },
    "emergency":    { ".read": true, ".write": "auth.token.admin === true" }
  }
}
```

> ⚠️ The `"bookings": { ".indexOn": ["userId"] }` rule is required for My Tickets to load correctly per user.

---

## 🛡️ Admin Panel

Admin access requires Firebase custom claim `admin: true`.

```javascript
// Run once via Firebase Admin SDK (Node.js)
admin.auth().setCustomUserClaims('USER_UID_HERE', { admin: true });
```

> User must sign out and sign back in after claim is set.

---

## 💳 Payment (Production Setup)

Currently uses direct booking confirmation. To enable real SSLCommerz payments:

1. Register at [sslcommerz.com](https://sslcommerz.com) → get Store ID + Store Password
2. In `lib/All Feautures/payments_Methods/payment_gateways.dart`:
```dart
static const _storeId = 'your_real_store_id';
static const _storePass = 'your_real_store_password';
// isSandbox: true → false
```

---

## 📦 Key Dependencies

```yaml
firebase_core: ^3.13.0
firebase_auth: ^5.5.0
firebase_database: ^11.3.0
firebase_crashlytics: ^4.3.0
firebase_analytics: ^11.4.0
firebase_messaging: ^15.2.5
get: ^4.6.6
google_maps_flutter: ^2.10.0
geolocator: ^13.0.2
pdf: ^3.11.1
printing: ^5.13.1
qr_flutter: ^4.1.0
shared_preferences: ^2.3.3
intl: ^0.19.0
```

---

## 👥 Team

**Group 05 — DBMS Project Lab, United International University**

| Name | Role |
|---|---|
| Ahnaf Wadud Arnab | Lead Developer |

---

## 📄 License

Academic purposes only. © 2025 United International University.

---

<div align="center">
Made with ❤️ in Bangladesh 🇧🇩
</div>
