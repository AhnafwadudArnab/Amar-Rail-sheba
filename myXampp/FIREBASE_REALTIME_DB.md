# Firebase Realtime Database — Flutter Guide

এই project এ `firebase_database: ^12.3.0` already add করা আছে।

---

## 1. Firebase Console এ Realtime Database Enable করো

1. [console.firebase.google.com](https://console.firebase.google.com) → **railwaysystems-7d372** project খোলো
2. বাম মেনু থেকে **Build → Realtime Database** click করো
3. **Create Database** click করো
4. Region: **asia-southeast1 (Singapore)** select করো (BD এর কাছে)
5. Security rules: **Start in test mode** select করো (development এর জন্য)
6. **Enable** click করো

---

## 2. pubspec.yaml

`firebase_database` already added:

```yaml
dependencies:
  firebase_core: ^4.7.0
  firebase_auth: ^6.4.0
  firebase_database: ^12.3.0
```

---

## 3. main.dart — Initialize

```dart
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
```

---

## 4. Database Reference তৈরি করো

```dart
import 'package:firebase_database/firebase_database.dart';

final db = FirebaseDatabase.instance.ref();
```

---

## 5. Data লেখা (Write)

### একটা value set করো
```dart
await db.child('users/user123').set({
  'name': 'Ahnaf',
  'email': 'aarnab222126@bscse.uiu.ac.bd',
  'phone': '01840658317',
});
```

### নতুন unique key দিয়ে push করো
```dart
final newRef = db.child('bookings').push();
await newRef.set({
  'userId': 'user123',
  'from': 'Dhaka (Kamalapur)',
  'to': 'Chattogram',
  'date': '2026-05-01',
  'class': 'Snigdha',
  'seats': [12, 13],
  'amount': 1800,
  'status': 'confirmed',
});
print('Booking ID: ${newRef.key}');
```

### শুধু কিছু field update করো (বাকিগুলো ঠিক থাকবে)
```dart
await db.child('users/user123').update({
  'phone': '01700000000',
});
```

---

## 6. Data পড়া (Read)

### একবার পড়ো (once)
```dart
final snapshot = await db.child('users/user123').get();
if (snapshot.exists) {
  final data = snapshot.value as Map;
  print(data['name']);
}
```

### Real-time listen করো (stream)
```dart
db.child('bookings').onValue.listen((event) {
  final data = event.snapshot.value as Map?;
  if (data != null) {
    data.forEach((key, value) {
      print('Booking $key: $value');
    });
  }
});
```

---

## 7. Data মুছে ফেলা (Delete)

```dart
await db.child('bookings/bookingId123').remove();
```

---

## 8. এই Project এ কোথায় কী Use করবে

| Feature | Database Path | Operation |
|---|---|---|
| User registration | `users/{userId}` | `set()` |
| User login info | `users/{userId}` | `get()` |
| Ticket booking | `bookings/{bookingId}` | `push()` |
| My tickets | `bookings` (filter by userId) | `onValue` |
| Train schedule | `trains/{trainId}` | `get()` |
| Announcements | `announcements` | `onValue` |
| Emergency contacts | `emergency` | `get()` |
| Lost & Found | `lostFound/{itemId}` | `push()` / `onValue` |
| Live train location | `liveLocation/{trainId}` | `onValue` (real-time) |

---

## 9. Real Example — Booking Save করো

```dart
import 'package:firebase_database/firebase_database.dart';

class FirebaseBookingService {
  final _db = FirebaseDatabase.instance.ref();

  // নতুন booking save করো
  Future<String> saveBooking({
    required String userId,
    required String from,
    required String to,
    required String date,
    required String travelClass,
    required List<int> seats,
    required double amount,
  }) async {
    final ref = _db.child('bookings').push();
    await ref.set({
      'userId': userId,
      'from': from,
      'to': to,
      'date': date,
      'class': travelClass,
      'seats': seats,
      'amount': amount,
      'status': 'confirmed',
      'createdAt': DateTime.now().toIso8601String(),
    });
    return ref.key!; // booking ID return করে
  }

  // user এর সব bookings আনো
  Future<List<Map>> getUserBookings(String userId) async {
    final snapshot = await _db.child('bookings')
        .orderByChild('userId')
        .equalTo(userId)
        .get();

    if (!snapshot.exists) return [];

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return data.entries.map((e) {
      final booking = Map<String, dynamic>.from(e.value as Map);
      booking['id'] = e.key;
      return booking;
    }).toList();
  }
}
```

---

## 10. Real Example — Live Train Location

```dart
// Train এর location real-time এ দেখাও
StreamBuilder(
  stream: FirebaseDatabase.instance
      .ref('liveLocation/subarna_express')
      .onValue,
  builder: (context, snapshot) {
    if (!snapshot.hasData) return CircularProgressIndicator();

    final data = snapshot.data!.snapshot.value as Map?;
    if (data == null) return Text('No data');

    return Text(
      'Lat: ${data['lat']}, Lng: ${data['lng']}\n'
      'Speed: ${data['speed']} km/h\n'
      'Next: ${data['nextStation']}',
    );
  },
)
```

---

## 11. Security Rules (Production এর আগে)

Firebase Console → Realtime Database → **Rules** tab এ এটা set করো:

```json
{
  "rules": {
    "users": {
      "$userId": {
        ".read": "$userId === auth.uid",
        ".write": "$userId === auth.uid"
      }
    },
    "bookings": {
      ".read": "auth != null",
      ".write": "auth != null"
    },
    "trains": {
      ".read": true,
      ".write": "auth.token.admin === true"
    },
    "announcements": {
      ".read": true,
      ".write": "auth.token.admin === true"
    },
    "liveLocation": {
      ".read": true,
      ".write": "auth.token.admin === true"
    },
    "lostFound": {
      ".read": true,
      ".write": "auth != null"
    }
  }
}
```

---

## 12. Database Structure (JSON)

```
railwaysystems-7d372/
├── users/
│   └── {userId}/
│       ├── name: "Ahnaf"
│       ├── email: "..."
│       └── phone: "..."
├── bookings/
│   └── {autoId}/
│       ├── userId: "..."
│       ├── from: "Dhaka (Kamalapur)"
│       ├── to: "Chattogram"
│       ├── date: "2026-05-01"
│       ├── class: "Snigdha"
│       ├── seats: [12, 13]
│       ├── amount: 1800
│       └── status: "confirmed"
├── trains/
│   └── {trainId}/
│       ├── name: "Subarna Express"
│       ├── code: "701"
│       └── schedule: {...}
├── liveLocation/
│   └── {trainId}/
│       ├── lat: 23.73
│       ├── lng: 90.42
│       ├── speed: 80
│       └── nextStation: "Comilla"
├── announcements/
│   └── {autoId}/
│       ├── title: "..."
│       └── body: "..."
└── lostFound/
    └── {autoId}/
        ├── item: "..."
        ├── location: "..."
        └── contact: "..."
```
