# 🚂 Amar Rail Sheba

**Bangladesh Railway Ticket Booking System**

A Flutter-based mobile and web application for booking train tickets, tracking live trains, and managing railway services in Bangladesh.

> 📚 **Academic Project** — DBMS Course (Group 05, United International University)

---

## ✨ Features

- Onboarding, Firebase Auth (login/register/forgot password)
- Train search — route, date, class, passenger count
- 60+ stations across all 8 divisions
- Interactive seat selection with coach map
- Digital tickets with QR code
- Live train tracking on Google Maps
- Lost & Found (report + claim)
- Emergency contacts
- Ratings & Reviews
- Admin panel
- Responsive — phone, tablet, web

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.x (Dart) |
| State Management | GetX |
| Auth & DB | Firebase Auth + Realtime Database |
| Maps | Google Maps Flutter |
| Location | Geolocator |
| Local Storage | SharedPreferences |
| QR Code | qr_flutter |

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

## 🔐 Firebase Security Rules

```json
{
  "rules": {
    "users": { "$uid": { ".read": "$uid === auth.uid", ".write": "$uid === auth.uid" } },
    "bookings": { ".read": "auth != null", ".write": "auth != null" },
    "lostFound": { ".read": true, ".write": "auth != null" },
    "liveLocation": { ".read": true, ".write": "auth.token.admin === true" },
    "reviews": { ".read": true, ".write": "auth != null" },
    "emergency": { ".read": true, ".write": "auth.token.admin === true" }
  }
}
```

---

## ✅ Production Checklist

> Everything below must be completed before this app can go live.
> Current status: **~30% production ready**

---

### 🔴 CRITICAL — Security

- [ ] **Restrict Google Maps API key**
  - File: `android/app/src/main/AndroidManifest.xml`
  - Key is hardcoded and public. Go to Google Cloud Console → restrict to this app's package name (`com.example.amarRailSheba`) and SHA-1 fingerprint.

- [ ] **Secure Firebase credentials**
  - File: `lib/firebase_options.dart`
  - Firebase API key, App ID, and DB URL are committed to source code. Move to environment variables or use Firebase App Check to restrict access.

- [ ] **Hash passwords before storing**
  - File: `lib/services/local_data_service.dart` → `register()` method
  - Passwords are saved as plain text in SharedPreferences. Use `crypto` package (SHA-256) or remove local auth fallback entirely and rely only on Firebase Auth.

- [ ] **Implement actual payment processing**
  - File: `lib/All Feautures/payments_Methods/payment_gateways.dart`
  - `BkashPayment.pay()`, `NagadPayment.pay()`, `CardPayment.pay()` are all empty stubs. Integrate a real payment gateway — SSLCommerz is the most common for Bangladesh (supports bKash, Nagad, card).

- [ ] **Add admin role verification**
  - File: `lib/ADMIN/adminPage.dart`
  - Admin panel has no access control. Any logged-in user can navigate to it. Check `auth.token.admin === true` via Firebase custom claims before showing admin UI.

---

### 🔴 CRITICAL — Build & Release

- [ ] **Configure Android release signing**
  - File: `android/app/build.gradle` (line ~37)
  - Release build uses debug keys (`signingConfig = signingConfigs.debug`). Create a production keystore:
    ```bash
    keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
    ```
  - Add signing config to `build.gradle` and store credentials in `key.properties` (gitignored).

- [ ] **Change application ID**
  - File: `android/app/build.gradle`
  - Current ID is `com.example.amarRailSheba`. Change to a unique ID like `com.amarrailsheba.app` before Play Store submission.

- [ ] **Update web app title**
  - File: `web/index.html`
  - Title is "trackers" and description is "A new Flutter project." Update to "Amar Rail Sheba".

---

### 🟠 HIGH — Data & Backend

- [ ] **Replace mock train data with real Firebase data**
  - File: `lib/services/local_data_service.dart` → `getTrains()`
  - Returns 4 hardcoded trains regardless of route or date. Query Firebase Realtime Database for actual schedules. Add a `trains/` node to the DB.

- [ ] **Fix hardcoded `userId: 'user_local'` in bookings**
  - File: `lib/All Feautures/Seat management/Train_Seat.dart` → `_confirmBooking()`
  - Replace with: `FirebaseAuth.instance.currentUser?.uid ?? ''`

- [ ] **Fix empty `arrivalTime` in bookings**
  - File: `lib/All Feautures/Seat management/Train_Seat.dart` → `_confirmBooking()`
  - `arrivalTime: ''` is hardcoded. Pass the actual arrival time from the train search result through to this screen.

- [ ] **Implement seat locking to prevent double-booking**
  - File: `lib/All Feautures/Seat management/Train_Seat.dart`
  - No mechanism prevents two users from booking the same seat simultaneously. Use Firebase transactions or a seat reservation system with a short TTL lock.

- [ ] **Implement Lost & Found search**
  - File: `lib/All Feautures/Maintainence/LostAndFound.dart` → `SearchFoundItemsPage`
  - Search page shows placeholder text. Implement Firebase query filtering by item name, date, or train number.

- [ ] **Fix claim process — hardcoded `itemId: 'unknown'`**
  - File: `lib/All Feautures/Maintainence/LostAndFound.dart` → `ClaimProcessPage._submit()`
  - Passes `'unknown'` as itemId. Pass the actual item's Firebase key.

- [ ] **Implement booking cancellation & refund logic**
  - Currently cancellation only updates status in DB. Add refund amount calculation and trigger refund via payment gateway.

---

### 🟠 HIGH — Error Handling

- [ ] **Add try-catch to all Firebase operations**
  - File: `lib/services/firebase_service.dart`
  - Methods like `getUserProfile()`, `updateProfile()`, `saveBooking()`, `getMyBookings()`, `trainLocationStream()`, `reportLostItem()`, `submitReview()`, `getEmergencyContacts()` have no error handling. Wrap each in try-catch and show user-friendly messages.

- [ ] **Handle Firebase init failure**
  - File: `lib/main.dart`
  - No error handling if `Firebase.initializeApp()` fails. Show an error screen instead of crashing.

- [ ] **Add error handling to booking confirmation**
  - File: `lib/All Feautures/Seat management/Train_Seat.dart` → `_confirmBooking()`
  - No try-catch. If save fails, user sees no feedback.

- [ ] **Handle location permission denial gracefully**
  - File: `lib/All Feautures/Tracking or live locations/Live_location.dart` → `_initLocation()`
  - `Geolocator.getCurrentPosition()` has no try-catch. Wrap it and show a proper message if it fails.

- [ ] **Handle null Firebase snapshot values**
  - File: `lib/services/firebase_service.dart`
  - `Map<String, dynamic>.from(snap.value as Map)` will crash if `snap.value` is null. Add null checks before casting.

---

### 🟠 HIGH — Validation

- [ ] **Validate email format on login**
  - File: `lib/Login&Signup/Login.dart`
  - Login email field only checks if empty. Use `EmailValidator.validate()` (package already imported in sign_up.dart).

- [ ] **Validate phone number format**
  - File: `lib/Login&Signup/sign_up.dart`
  - Phone field only checks if empty. Bangladesh numbers must be 11 digits starting with 01. Add regex: `^01[3-9]\d{8}$`

- [ ] **Validate departure date is not in the past**
  - File: `lib/All Feautures/firstpage/booking.dart` → `_pickDate()`
  - Date picker allows past dates. Set `firstDate: DateTime.now()`.

- [ ] **Validate return date is after departure**
  - File: `lib/All Feautures/firstpage/booking.dart`
  - Only partially validated. Ensure return date picker's `firstDate` is set to departure date + 1 day.

- [ ] **Validate payment amount**
  - File: `lib/All Feautures/payments_Methods/Payments.dart`
  - No check that total amount > 0 or matches seat count × price.

---

### 🟠 HIGH — Features

- [ ] **Replace simulated live tracking with real data**
  - File: `lib/All Feautures/Tracking or live locations/Live_location.dart`
  - Uses `TrainSimulator` for demo. Requires a backend service (or admin app) that writes real GPS coordinates to `liveLocation/{trainId}` in Firebase. The app already reads from this path — just needs real data.

- [ ] **Complete admin panel CRUD operations**
  - File: `lib/ADMIN/adminPage.dart`
  - Train management, announcements, and lost & found tabs are incomplete. Wire all admin actions to Firebase.

- [ ] **Add push notifications**
  - No booking confirmation, cancellation, or status update notifications. Integrate `firebase_messaging` for push notifications.

- [ ] **Add booking confirmation email/SMS**
  - No email or SMS sent after booking. Use Firebase Functions + SendGrid/Twilio or a similar service.

---

### 🟡 MEDIUM — Code Quality

- [x] **Remove debug print statements** ✅
  - Removed all `kDebugMode` + `print()` blocks from: `payment_gateways.dart`, `emergencies.dart`, `TrainInfo.dart`, `ticketUpcoming.dart`, `login_ex.dart`, `registrations.dart`, `seatAPI.dart`

- [x] **Pin `http` package version** ✅
  - `pubspec.yaml`: `http: any` → `http: ^1.2.0`

- [ ] **Add crash reporting**
  - Add `firebase_crashlytics: ^4.1.0` to `pubspec.yaml`
  - In `main.dart` add: `FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;`

- [ ] **Add analytics**
  - Add `firebase_analytics: ^11.3.0` to `pubspec.yaml`
  - Log key events: booking started, payment attempted, search performed

- [x] **Add session expiration** ✅
  - `lib/services/local_data_service.dart`: sessions now expire after 30 days. `getUserSession()` auto-clears expired sessions and returns null to force re-login.

- [x] **Add loading states & empty screens** ✅
  - `lib/main.dart`: Firebase init shows splash screen + loading indicator, error screen on failure
  - `lib/All Feautures/second pagee/Book_page_after_search.dart`: empty state when no trains found
  - `lib/All Feautures/Dynamic Tickets/TicketDetails.dart`: empty states for upcoming/past tickets
  - `lib/All Feautures/Maintainence/LostAndFound.dart`: `SearchFoundItemsPage` loads real Firebase data with spinner + empty state + working search

- [ ] **Add rate limiting on login**
  - Firebase Auth handles brute-force for Firebase login automatically
  - For local auth fallback: add failed-attempt counter in SharedPreferences, lock after 5 attempts for 15 minutes

- [x] **Update web app title** ✅
  - `web/index.html`: title, description, and apple-mobile-web-app-title all updated to "Amar Rail Sheba"

---

### 🟡 MEDIUM — UI/UX Polish

- [ ] **Add app icon**
  - Default Flutter icon is used. Use `flutter_launcher_icons` package to set a custom icon.

- [x] **Add splash screen** ✅
  - `lib/main.dart`: custom splash screen shown during Firebase initialization (train icon, app name, progress indicator)

- [ ] **Add screenshots to README**
  - Screenshots section is empty.

- [x] **Add empty state screens** ✅
  - My Tickets: "No upcoming/past tickets" with icon and subtitle
  - Lost & Found search: "No items found" with icon
  - Train search results: "No trains found" with icon

- [ ] **Add profile picture upload**
  - Profile page has no photo upload. Integrate Firebase Storage.

---

## 📦 Dependencies

```yaml
firebase_core: ^4.7.0
firebase_auth: ^6.4.0
firebase_database: ^12.3.0
get: ^4.6.6
google_maps_flutter: ^2.10.0
geolocator: ^13.0.2
shared_preferences: ^2.3.3
qr_flutter: ^4.1.0
url_launcher: ^6.0.20
fluttertoast: ^8.0.8
intl: ^0.19.0
```

---

## 👥 Team

**Group 05 — DBMS Project Lab, United International University**

| Name | Role |
|------|------|
| Ahnaf Wadud Arnab | Lead Developer |

---

## 📄 License

Academic purposes only. © 2024 United International University.

---

<p align="center">Made with ❤️ in Bangladesh 🇧🇩</p>
