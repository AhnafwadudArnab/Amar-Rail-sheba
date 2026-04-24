# 🚂 Amar Rail Sheba

A Flutter-based Bangladesh Railway ticket booking app — built as a DBMS course project (Group 05, United International University).

---

## 📱 Screenshots

> _Add screenshots here_

---

## ✨ Features

- **Onboarding** — animated intro slides on first launch
- **Authentication** — register & login via Firebase Auth
- **Train Search** — one-way & round-trip booking with date, class, and passenger selection
- **60+ Stations** — all major Bangladesh Railway stations across every division
- **Seat Selection** — interactive coach/seat map with class filtering
- **My Tickets** — view upcoming and past bookings with QR code
- **Live Tracking** — real-time train location on Google Maps with route polylines
- **Emergency** — quick access to railway emergency contacts
- **Lost & Found** — report and search lost items (Firebase backed)
- **Train Info** — schedules, routes, and train details
- **Ratings & Reviews** — leave feedback on journeys (Firebase backed)
- **Admin Panel** — manage trains and schedules
- **Privacy Policy** — in-app policy page
- **Profile** — view and edit user profile, update password

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x (Dart) |
| State Management | GetX |
| Auth | Firebase Authentication |
| Database | Firebase Realtime Database |
| Maps | Google Maps Flutter |
| Location | Geolocator + Location |
| Local Storage | SharedPreferences |
| QR Code | qr_flutter |
| Notifications | fluttertoast |

---

## 📁 Project Structure

```
lib/
├── main.dart                        # App entry point + Firebase init
├── profileBar.dart                  # User profile page
├── OnBoards/                        # Onboarding slides
├── Login&Signup/                    # Auth screens (Login, SignUp, ForgetPassword)
├── All Feautures/
│   ├── firstpage/                   # Home booking page
│   ├── second pagee/                # Train search results
│   ├── Dynamic Tickets/             # Ticket display & QR
│   ├── Seat management/             # Seat selection
│   ├── Payments/                    # Payment flow
│   ├── Tracking or live locations/  # Live map
│   ├── Emergencies/                 # Emergency contacts
│   └── Maintainence/                # Lost & Found, About, Privacy Policy
├── Info page/                       # Announcements, Reviews, Train Info
├── ADMIN/                           # Admin panel
├── services/
│   ├── firebase_service.dart        # ⭐ All Firebase operations
│   ├── local_data_service.dart      # Local mock data & SharedPreferences
│   └── train_route_data.dart        # Station coordinates & routes
├── utils/                           # Responsive helper (R class)
└── Widgets/                         # Reusable UI components

myXampp/                             # Old Node.js + MySQL backend (archived)
├── nodejs update/                   # Express API server
├── FIREBASE_REALTIME_DB.md          # Firebase DB usage guide
└── ppp/                             # Earlier API prototype
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `^3.5.4`
- Dart SDK
- Android Studio / VS Code
- A Google Maps API key
- A Firebase project (already configured — see below)

---

### Step 1 — Clone & Install

```bash
git clone https://github.com/AhnafwadudArnab/Amar-Rail-sheba.git
cd Amar-Rail-sheba
flutter pub get
```

---

### Step 2 — Firebase Setup

The app uses **Firebase project: `railwaysystems-7d372`**

1. Go to [console.firebase.google.com](https://console.firebase.google.com)
2. Open project **railwaysystems-7d372**
3. Go to ⚙️ **Project Settings → Your apps → Android**
4. Download `google-services.json`
5. Place it at `android/app/google-services.json`

> ✅ Package name must be `com.example.amarRailSheba`

**Enable these Firebase services:**

| Service | How to enable |
|---|---|
| Authentication | Build → Authentication → Sign-in method → Email/Password → Enable |
| Realtime Database | Build → Realtime Database → Create Database → asia-southeast1 → Test mode |

**Realtime Database URL:**
```
https://railwaysystems-7d372-default-rtdb.asia-southeast1.firebasedatabase.app
```

---

### Step 3 — Google Maps API Key

The key is already set in `android/app/src/main/AndroidManifest.xml`.
If you need to replace it:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_KEY_HERE"/>
```

---

### Step 4 — Run the App

```bash
flutter run
```

---

## 🔥 Firebase Database Structure

```
railwaysystems-7d372/
├── users/{uid}/
│   ├── name, email, phone, createdAt
├── bookings/{autoId}/
│   ├── userId, from, to, date, class, trainName
│   ├── seats, totalAmount, status, createdAt
├── lostFound/{autoId}/
│   ├── type (lost/found), itemName, description
│   ├── trainDetails, contactDetails, status
├── liveLocation/{trainId}/
│   ├── lat, lng, speed, nextStation, updatedAt
├── reviews/{trainId}/{autoId}/
│   ├── userId, rating, comment, createdAt
└── emergency/
    └── contacts list
```

---

## 🔐 Firebase Security Rules

Set these in Firebase Console → Realtime Database → Rules:

```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid"
      }
    },
    "bookings": {
      ".read": "auth != null",
      ".write": "auth != null"
    },
    "lostFound": {
      ".read": true,
      ".write": "auth != null"
    },
    "liveLocation": {
      ".read": true,
      ".write": "auth.token.admin === true"
    },
    "reviews": {
      ".read": true,
      ".write": "auth != null"
    },
    "emergency": {
      ".read": true,
      ".write": "auth.token.admin === true"
    }
  }
}
```

---

## 📦 Key Dependencies

```yaml
firebase_core: ^4.7.0          # Firebase initialization
firebase_auth: ^6.4.0          # Email/password authentication
firebase_database: ^12.3.0     # Realtime database
get: ^4.6.6                    # State management & navigation
google_maps_flutter: ^2.10.0   # Maps & live tracking
geolocator: ^13.0.2            # Device location
shared_preferences: ^2.3.3     # Local data persistence
qr_flutter: ^4.1.0             # QR code generation
url_launcher: ^6.0.20          # Open links & emails
fluttertoast: ^8.0.8           # Toast notifications
intl: ^0.19.0                  # Date formatting
```

---

## 👥 Team

**Group 05 — DBMS Project Lab**
United International University

| Name | Role |
|---|---|
| Ahnaf Wadud Arnab | Lead Developer |

---

## 📄 License

This project is for academic purposes only.
