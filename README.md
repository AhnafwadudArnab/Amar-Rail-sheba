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

- [x] **Replace mock train data with real Firebase data** ✅
  - `lib/services/local_data_service.dart`: Added `getTrainsAsync()` — queries `trains/` node in Firebase filtered by route, falls back to mock data if empty
  - `lib/All Feautures/second pagee/Book_page_after_search.dart`: Now calls `getTrainsAsync()` with loading spinner

- [x] **Fix hardcoded `userId: 'user_local'` in bookings** ✅
  - Uses `FirebaseAuth.instance.currentUser?.uid`

- [x] **Fix empty `arrivalTime` in bookings** ✅
  - Reads from `widget.outboundTrain?.arrivalTime`

- [x] **Implement seat locking to prevent double-booking** ✅
  - `lib/All Feautures/Seat management/Train_Seat.dart`: Firebase transaction on `seatLocks/{trainId}/{date}/{coach}` — atomically checks and locks seats with 10-min TTL. Shows error and clears selection if seat already taken. Releases lock on save failure.

- [x] **Implement Lost & Found search** ✅
  - `SearchFoundItemsPage` loads real Firebase data, filters by item name or train details, shows loading spinner and empty state

- [x] **Fix claim process — hardcoded `itemId: 'unknown'`** ✅
  - `ClaimProcessPage` now accepts `itemId` + `itemName`. `SearchFoundItemsPage` passes real Firebase key. Validates before submitting.

- [x] **Implement booking cancellation & refund logic** ✅
  - `lib/services/firebase_service.dart` → `cancelBooking()`: 100% refund if 24h+ before journey, 50% otherwise. Saves `refundAmount`, `refundStatus: 'pending'`, `cancelledAt` to Firebase.

---

### 🟠 HIGH — Error Handling

- [x] **Add try-catch to all Firebase operations** ✅
  - `lib/services/firebase_service.dart`: All methods now have try-catch with user-friendly error messages (`getUserProfile`, `updateProfile`, `saveBooking`, `getMyBookings`, `trainLocationStream`, `reportLostItem`, `reportFoundItem`, `submitClaim`, `submitReview`, `getEmergencyContacts`)

- [x] **Handle Firebase init failure** ✅
  - `lib/main.dart`: Already handled — shows error screen if Firebase init fails

- [x] **Add error handling to booking confirmation** ✅
  - `lib/All Feautures/Seat management/Train_Seat.dart` → `_confirmBooking()`: Now wrapped in try-catch with SnackBar feedback

- [x] **Handle location permission denial gracefully** ✅
  - `lib/All Feautures/Tracking or live locations/Live_location.dart`: `getCurrentPosition()` already has try-catch, added `onError` handler to position stream

- [x] **Handle null Firebase snapshot values** ✅
  - `lib/services/firebase_service.dart`: All snapshot reads now check `snap.value == null` before casting

---

### 🟠 HIGH — Validation

- [x] **Validate email format on login** ✅
  - `lib/Login&Signup/Login.dart`: Now uses `EmailValidator.validate()` (package already imported)

- [x] **Validate phone number format** ✅
  - `lib/Login&Signup/sign_up.dart`: Added regex validation for Bangladesh numbers (`^01[3-9]\d{8}$`)

- [x] **Validate departure date is not in the past** ✅
  - `lib/All Feautures/firstpage/booking.dart` → `_pickDate()`: Already correct — `firstDate` is set to `DateTime.now()` for departure, and `_departDate` for return

- [x] **Validate return date is after departure** ✅
  - `lib/All Feautures/firstpage/booking.dart`: Already enforced — return date picker's `firstDate` is set to `_departDate`

- [x] **Validate payment amount** ✅
  - `lib/All Feautures/payments_Methods/Payments.dart` → `_pay()`: Added validation for `totalAmount > 0` and `selectedSeats.isEmpty`

---

### 🟠 HIGH — Features

- [x] **Replace simulated live tracking with real data** ✅ (partial)
  - App already reads from `liveLocation/{trainId}` via `trainLocationStream()`. Simulator runs as fallback.
  - To go fully live: deploy a backend/Firebase Function that writes real GPS to `liveLocation/{trainId}` every 30s.

- [x] **Complete admin panel CRUD operations** ✅
  - Dashboard (live stats), Trains (add/delete), Bookings (confirm/cancel/filter), Users (list), Announcements (post/pin/delete), Lost & Found (resolve/reopen/delete) — all wired to Firebase

- [x] **Add push notifications** ✅
  - Added `firebase_messaging: ^15.1.0` to `pubspec.yaml`
  - Created `lib/services/notification_service.dart` — permission request, FCM token, foreground toast, background tap handler
  - Wired into `main.dart`

- [ ] **Add booking confirmation email/SMS**
  - Requires Firebase Functions + SendGrid (email) or Twilio/Bangladesh SMS gateway
  - `NotificationService.bookingConfirmedPayload()` provides the payload structure ready for server-side use

---

### 🟡 MEDIUM — Code Quality

- [x] **Remove debug print statements** ✅
  - Removed all `kDebugMode` + `print()` blocks from: `payment_gateways.dart`, `emergencies.dart`, `TrainInfo.dart`, `ticketUpcoming.dart`, `login_ex.dart`, `registrations.dart`, `seatAPI.dart`

- [x] **Pin `http` package version** ✅
  - `pubspec.yaml`: `http: any` → `http: ^1.2.0`

- [x] **Add crash reporting** ✅
  - Added `firebase_crashlytics: ^4.1.0` to `pubspec.yaml`
  - `lib/main.dart`: Wired `FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;`

- [x] **Add analytics** ✅
  - Added `firebase_analytics: ^11.3.0` to `pubspec.yaml`
  - Ready to log events (booking started, payment attempted, search performed, etc.)

- [x] **Add session expiration** ✅
  - `lib/services/local_data_service.dart`: sessions now expire after 30 days. `getUserSession()` auto-clears expired sessions and returns null to force re-login.

- [x] **Add loading states & empty screens** ✅
  - `lib/main.dart`: Firebase init shows splash screen + loading indicator, error screen on failure
  - `lib/All Feautures/second pagee/Book_page_after_search.dart`: empty state when no trains found
  - `lib/All Feautures/Dynamic Tickets/TicketDetails.dart`: empty states for upcoming/past tickets
  - `lib/All Feautures/Maintainence/LostAndFound.dart`: `SearchFoundItemsPage` loads real Firebase data with spinner + empty state + working search

- [x] **Add rate limiting on login** ✅
  - `lib/services/local_data_service.dart` → `login()`: Max 5 failed attempts, then 15-min lockout. Counter stored in SharedPreferences per email. Resets on successful login or after lockout expires.

- [x] **Update web app title** ✅
  - `web/index.html`: title, description, and apple-mobile-web-app-title all updated to "Amar Rail Sheba"

---

### 🟡 MEDIUM — UI/UX Polish

- [x] **Add app icon** ✅ (config ready)
  - Added `flutter_launcher_icons: ^0.14.1` to dev_dependencies
  - Config added to `pubspec.yaml` — place icon at `assets/icon/app_icon.png` (1024×1024), then run:
    ```bash
    flutter pub run flutter_launcher_icons
    ```

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
