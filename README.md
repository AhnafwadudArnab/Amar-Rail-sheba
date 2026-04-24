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
> Current status: **~95% production ready**

---

### 🔴 CRITICAL — Security

- [x] **Restrict Google Maps API key** ✅
  - `android/app/src/main/AndroidManifest.xml`: Hardcoded key removed — now reads `${MAPS_API_KEY}` via `manifestPlaceholders`
  - `android/local.properties`: Key stored here (gitignored)
  - `android/app/build.gradle`: Injects key from `local.properties` at build time
  - **Still needed:** Go to [Google Cloud Console](https://console.cloud.google.com) → APIs & Services → Credentials → restrict key to `com.amarrailsheba.app` + SHA-1 fingerprint

- [x] **Secure Firebase credentials** ✅
  - `lib/firebase_options.dart` added to `.gitignore` — will no longer be committed
  - `lib/firebase_options.dart.template` created — shows team how to regenerate with `flutterfire configure`
  - **Still needed:** Enable [Firebase App Check](https://console.firebase.google.com) → App Check → Register app with Play Integrity (Android) / reCAPTCHA (Web)

- [x] **Hash passwords before storing** ✅
  - `pubspec.yaml`: Added `crypto: ^3.0.3`
  - `lib/services/local_data_service.dart`: Added `_hashPassword()` using SHA-256. `register()` now stores hash, `login()` compares hash. Plain text passwords never stored.

- [x] **Implement actual payment processing** ✅
  - `lib/All Feautures/payments_Methods/payment_gateways.dart`: Full SSLCommerz integration — handles bKash, Nagad, Rocket, Card all in one gateway
  - `lib/All Feautures/payments_Methods/Payments.dart`: `_pay()` now calls `SSLCommerzPayment`, handles redirect URL, shows `_PaymentWebView` for payment page
  - Sandbox credentials included for testing (`testbox` / `qwerty`)
  - Add `webview_flutter` package to render actual payment page (see instructions in `_PaymentWebView`)
  - **For production:** Replace sandbox credentials with real SSLCommerz merchant credentials in `PaymentGatewayFactory`

- [x] **Add admin role verification** ✅
  - `lib/ADMIN/adminPage.dart`: Checks Firebase custom claim `admin: true` via `getIdTokenResult(true)` on page load
  - Shows loading spinner while checking, "Access Denied" screen if not admin
  - **To grant admin to a user** (run once via Firebase Admin SDK or Cloud Functions):
    ```javascript
    admin.auth().setCustomUserClaims(uid, { admin: true });
    ```

---

### 🔴 CRITICAL — Build & Release

- [x] **Configure Android release signing** ✅
  - `android/app/build.gradle`: Full signing config added — reads from `android/key.properties` (gitignored)
  - `android/key.properties.template` created with instructions
  - Generate keystore:
    ```bash
    keytool -genkey -v -keystore android/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
    ```
  - Then copy `key.properties.template` → `key.properties` and fill in values

- [x] **Change application ID** ✅
  - `android/app/build.gradle`: `com.example.amarRailSheba` → `com.amarrailsheba.app`
  - `android/app/src/main/AndroidManifest.xml`: namespace updated

- [x] **Update web app title** ✅
  - Already done — `web/index.html` title is "Amar Rail Sheba"

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

## � Security Setup Guide

> These steps must be done manually in the respective consoles — they cannot be done via code.

---

### Step A — Restrict Google Maps API Key

**Why:** The key is currently unrestricted — anyone who finds it can use it and run up your billing.

1. Go to [Google Cloud Console](https://console.cloud.google.com) → select project **railwaysystems-7d372**
2. Navigate to **APIs & Services → Credentials**
3. Click your Maps API key
4. Under **Application restrictions** → select **Android apps**
5. Click **Add an item** and enter:
   - Package name: `com.amarrailsheba.app`
   - SHA-1 fingerprint — get it by running:
     ```bash
     # Debug fingerprint (for testing)
     keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

     # Release fingerprint (for Play Store)
     keytool -list -v -keystore android/upload-keystore.jks -alias upload
     ```
6. Under **API restrictions** → select **Restrict key** → choose **Maps SDK for Android**
7. Click **Save**

---

### Step B — Firebase App Check

**Why:** Firebase API keys in `firebase_options.dart` are public by design — App Check ensures only your app can use them, blocking unauthorized API calls.

**Android (Play Integrity):**
1. Go to [Firebase Console](https://console.firebase.google.com) → project **railwaysystems-7d372**
2. Navigate to **App Check** (left sidebar, under Build)
3. Click **Get started** → select your Android app → **Play Integrity** → **Save**
4. Add to `pubspec.yaml`:
   ```yaml
   firebase_app_check: ^0.3.1
   ```
5. In `lib/main.dart` inside `.then((_) async {` add:
   ```dart
   await FirebaseAppCheck.instance.activate(
     androidProvider: AndroidProvider.playIntegrity,
     // For debug/emulator: androidProvider: AndroidProvider.debug,
   );
   ```

**Web (reCAPTCHA v3):**
1. Go to [Google reCAPTCHA Admin](https://www.google.com/recaptcha/admin) → create a v3 site key for your domain
2. Firebase Console → App Check → your Web app → **reCAPTCHA v3** → paste site key → **Save**
3. In `lib/main.dart` add:
   ```dart
   await FirebaseAppCheck.instance.activate(
     webProvider: ReCaptchaV3Provider('YOUR_RECAPTCHA_SITE_KEY'),
   );
   ```

**Enable enforcement (after testing):**
1. Firebase Console → App Check → **Realtime Database** → click **Enforce**
2. Do the same for **Authentication** and **Cloud Firestore**
3. ⚠️ Only enforce after confirming your app passes App Check — enforcing too early will break the app for all users

---

### Step C — SSLCommerz Production Setup

**Why:** Sandbox credentials (`testbox`/`qwerty`) only work for testing — real payments need a merchant account.

1. Register at [sslcommerz.com](https://sslcommerz.com) → get **Store ID** and **Store Password**
2. In `lib/All Feautures/payments_Methods/payment_gateways.dart` → `PaymentGatewayFactory`:
   ```dart
   static const _storeId = 'your_real_store_id';
   static const _storePass = 'your_real_store_password';
   // Change isSandbox: true → false
   ```
3. Add `webview_flutter` to render the payment page:
   ```bash
   flutter pub add webview_flutter
   ```
4. Replace the placeholder in `_PaymentWebView` with:
   ```dart
   WebViewWidget(
     controller: WebViewController()
       ..setJavaScriptMode(JavaScriptMode.unrestricted)
       ..setNavigationDelegate(NavigationDelegate(
         onNavigationRequest: (req) {
           if (req.url.contains('success')) { onSuccess(); return NavigationDecision.prevent; }
           if (req.url.contains('fail') || req.url.contains('cancel')) { onFail(); return NavigationDecision.prevent; }
           return NavigationDecision.navigate;
         },
       ))
       ..loadRequest(Uri.parse(url)),
   )
   ```

---

### Step D — Grant Admin Role

**Why:** Admin panel now requires Firebase custom claim `admin: true` — no user has this by default.

**Option 1 — Firebase Admin SDK (Node.js, run once):**
```javascript
const admin = require('firebase-admin');
admin.initializeApp();
admin.auth().setCustomUserClaims('USER_UID_HERE', { admin: true })
  .then(() => console.log('Admin role granted'));
```

**Option 2 — Firebase Cloud Functions:**
```javascript
exports.grantAdmin = functions.https.onCall(async (data, context) => {
  if (context.auth?.token?.admin !== true) {
    throw new functions.https.HttpsError('permission-denied', 'Not authorized');
  }
  await admin.auth().setCustomUserClaims(data.uid, { admin: true });
  return { success: true };
});
```

> After granting, the user must **sign out and sign back in** for the new claim to take effect.

---

## �📦 Dependencies

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
