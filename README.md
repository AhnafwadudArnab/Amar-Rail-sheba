# 🚂 Amar Rail Sheba

**Bangladesh Railway Ticket Booking System**

A Flutter-based mobile and web application for booking train tickets, tracking live trains, and managing railway services in Bangladesh.

> 📚 **Academic Project** — DBMS Course (Group 05, United International University)

---

## ✨ Features

| Feature | Description |
|---|---|
| 🔐 Auth | Firebase login / register / forgot password |
| 🔍 Train Search | Route, date, class, passenger count (1–4) |
| 🗺️ 60+ Stations | All 8 divisions of Bangladesh |
| 💺 Seat Selection | Interactive coach map, passenger-count enforced limit |
| 🎫 Digital Tickets | PDF download, monthly grouped in My Tickets |
| 📍 Live Tracking | Real-time train location on Google Maps |
| 🔔 Push Notifications | Firebase Cloud Messaging |
| 🧳 Lost & Found | Report + claim system |
| 🚨 Emergency Contacts | Quick access to railway emergency numbers |
| ⭐ Ratings & Reviews | Per-train reviews |
| 🛡️ Admin Panel | Trains, bookings, users, announcements |
| 📱 Responsive | Phone, tablet, web |

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

## 🎫 Booking Flow

```
Search Train → Select Seats → Payment → Ticket Generated → Saved to My Tickets
```

- **Seat limit:** Exactly matches passenger count selected at search
- **Weekly limit:** Max 4 tickets per user per week (Mon–Sun)
- **Seat locking:** Firebase transaction locks seats for 10 minutes during payment
- **Payment:** Direct booking confirmation (SSLCommerz integration ready for production)

---

## 📄 My Tickets

- Tickets grouped by **month** (e.g. April 2026, March 2026)
- Each ticket shows: route, date, seat(s), class, amount, status
- **Download as PDF** — web triggers browser download, mobile opens share dialog
- Tap any ticket to view full ticket detail with barcode

---

## 🔐 Firebase Security Rules

Apply these in Firebase Console → Realtime Database → Rules:

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
    "lostFound": { ".read": true, ".write": "auth != null" },
    "liveLocation": { ".read": true, ".write": "auth.token.admin === true" },
    "reviews": { ".read": true, ".write": "auth != null" },
    "emergency": { ".read": true, ".write": "auth.token.admin === true" }
  }
}
```

> ⚠️ The `"bookings": { ".indexOn": ["userId"] }` rule is required for My Tickets to load correctly per user.

---

## 🚆 Train Routes & Names

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

## 🛡️ Admin Panel

Admin access requires Firebase custom claim `admin: true`.

**Grant admin role (run once via Firebase Admin SDK):**
```javascript
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
3. Add `webview_flutter` to render the payment page

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

<p align="center">Made with ❤️ in Bangladesh 🇧🇩</p>
