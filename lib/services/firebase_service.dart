import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Single entry point for all Firebase Realtime DB + Auth operations
class FirebaseService {
  static final FirebaseService _i = FirebaseService._();
  factory FirebaseService() => _i;
  FirebaseService._();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseDatabase.instance.ref();

  // ── current user ──────────────────────────────────────────────────────────
  User? get currentUser => _auth.currentUser;
  String? get uid => _auth.currentUser?.uid;
  bool get isLoggedIn => _auth.currentUser != null;

  // ════════════════════════════════════════════════════════════════════════════
  // AUTH
  // ════════════════════════════════════════════════════════════════════════════

  /// Register with email + password, then save profile to DB
  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await cred.user?.updateDisplayName(name);
      // Save extra info to DB
      await _db.child('users/${cred.user!.uid}').set({
        'name': name,
        'email': email,
        'phone': phone,
        'createdAt': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      _toast('Registration failed: ${_authError(e)}', error: true);
      return false;
    }
  }

  /// Login with email + password
  Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      _toast('Login failed: ${_authError(e)}', error: true);
      return false;
    }
  }

  /// Logout
  Future<void> logout() async => await _auth.signOut();

  /// Send password reset email
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _toast('Password reset email sent!');
    } catch (e) {
      _toast('Error: ${_authError(e)}', error: true);
    }
  }

  /// Get current user profile from DB
  Future<Map<String, dynamic>?> getUserProfile() async {
    if (uid == null) return null;
    try {
      final snap = await _db.child('users/$uid').get();
      if (!snap.exists || snap.value == null) return null;
      return Map<String, dynamic>.from(snap.value as Map);
    } catch (e) {
      _toast('Failed to load profile', error: true);
      return null;
    }
  }

  /// Update user profile fields
  Future<void> updateProfile(Map<String, dynamic> data) async {
    if (uid == null) return;
    try {
      await _db.child('users/$uid').update(data);
    } catch (e) {
      _toast('Failed to update profile', error: true);
    }
  }

  // ════════════════════════════════════════════════════════════════════════════
  // BOOKINGS
  // ════════════════════════════════════════════════════════════════════════════

  /// Save a new booking, returns the booking ID
  Future<String?> saveBooking({
    required String from,
    required String to,
    required String date,
    required String travelClass,
    required String trainName,
    required String trainCode,
    required String departureTime,
    required String arrivalTime,
    required List<int> seats,
    required String coachName,
    required double totalAmount,
    bool isRoundTrip = false,
    String passengerName = '',
  }) async {
    if (uid == null) {
      _toast('Please login first', error: true);
      return null;
    }
    try {
      final ref = _db.child('bookings').push();
      await ref.set({
        'userId': uid,
        'name': passengerName,
        'from': from,
        'to': to,
        'date': date,
        'class': travelClass,
        'trainName': trainName,
        'trainCode': trainCode,
        'departureTime': departureTime,
        'arrivalTime': arrivalTime,
        'seats': seats,
        'coachName': coachName,
        'totalAmount': totalAmount,
        'isRoundTrip': isRoundTrip,
        'status': 'confirmed',
        'createdAt': DateTime.now().toIso8601String(),
      });
      return ref.key;
    } catch (e) {
      _toast('Failed to save booking. Please try again.', error: true);
      return null;
    }
  }

  /// Get all bookings for current user (one-time fetch)
  Future<List<Map<String, dynamic>>> getMyBookings() async {
    if (uid == null) return [];
    try {
      // Try indexed query first
      final snap = await _db
          .child('bookings')
          .orderByChild('userId')
          .equalTo(uid)
          .get();
      if (snap.exists && snap.value != null) {
        final raw = Map<String, dynamic>.from(snap.value as Map);
        return raw.entries.map((e) {
          final m = Map<String, dynamic>.from(e.value as Map);
          m['id'] = e.key;
          return m;
        }).toList()
          ..sort((a, b) => (b['createdAt'] as String? ?? '')
              .compareTo(a['createdAt'] as String? ?? ''));
      }
      return [];
    } catch (_) {
      // Fallback: fetch all bookings and filter client-side
      // (works without Firebase index rule)
      try {
        final snap = await _db.child('bookings').get();
        if (!snap.exists || snap.value == null) return [];
        final raw = Map<String, dynamic>.from(snap.value as Map);
        return raw.entries
            .map((e) {
              final m = Map<String, dynamic>.from(e.value as Map);
              m['id'] = e.key;
              return m;
            })
            .where((m) => m['userId'] == uid)
            .toList()
          ..sort((a, b) => (b['createdAt'] as String? ?? '')
              .compareTo(a['createdAt'] as String? ?? ''));
      } catch (e) {
        _toast('Failed to load bookings', error: true);
        return [];
      }
    }
  }

  /// Stream of current user's bookings (real-time)
  Stream<List<Map<String, dynamic>>> myBookingsStream() {
    if (uid == null) return const Stream.empty();
    return _db
        .child('bookings')
        .orderByChild('userId')
        .equalTo(uid)
        .onValue
        .map((event) {
      if (!event.snapshot.exists) return [];
      final raw = Map<String, dynamic>.from(event.snapshot.value as Map);
      return raw.entries.map((e) {
        final m = Map<String, dynamic>.from(e.value as Map);
        m['id'] = e.key;
        return m;
      }).toList()
        ..sort((a, b) => (b['createdAt'] as String)
            .compareTo(a['createdAt'] as String));
    });
  }

  /// Cancel a booking and record refund amount
  Future<void> cancelBooking(String bookingId) async {
    try {
      final snap = await _db.child('bookings/$bookingId').get();
      if (!snap.exists || snap.value == null) {
        _toast('Booking not found', error: true);
        return;
      }
      final booking = Map<String, dynamic>.from(snap.value as Map);
      final total = (booking['totalAmount'] as num?)?.toDouble() ?? 0;
      // Refund policy: 100% if cancelled 24h+ before journey, 50% otherwise
      final journeyDate = DateTime.tryParse(booking['date'] ?? '');
      final hoursUntil = journeyDate != null
          ? journeyDate.difference(DateTime.now()).inHours
          : 0;
      final refundPct = hoursUntil >= 24 ? 1.0 : 0.5;
      final refundAmount = (total * refundPct).toStringAsFixed(2);

      await _db.child('bookings/$bookingId').update({
        'status': 'cancelled',
        'cancelledAt': DateTime.now().toIso8601String(),
        'refundAmount': refundAmount,
        'refundStatus': 'pending',
      });
      _toast('Booking cancelled. Refund ৳$refundAmount will be processed within 3-5 days.');
    } catch (e) {
      _toast('Failed to cancel booking. Try again.', error: true);
    }
  }

  // ════════════════════════════════════════════════════════════════════════════
  // TRAINS
  // ════════════════════════════════════════════════════════════════════════════

  /// Get all trains (one-time)
  Future<List<Map<String, dynamic>>> getTrains() async {
    final snap = await _db.child('trains').get();
    if (!snap.exists) return [];
    final raw = Map<String, dynamic>.from(snap.value as Map);
    return raw.entries.map((e) {
      final m = Map<String, dynamic>.from(e.value as Map);
      m['id'] = e.key;
      return m;
    }).toList();
  }

  // ════════════════════════════════════════════════════════════════════════════
  // LIVE LOCATION
  // ════════════════════════════════════════════════════════════════════════════

  /// Stream real-time location of a train
  Stream<Map<String, dynamic>?> trainLocationStream(String trainId) {
    return _db.child('liveLocation/$trainId').onValue.map((event) {
      if (!event.snapshot.exists || event.snapshot.value == null) return null;
      return Map<String, dynamic>.from(event.snapshot.value as Map);
    });
  }

  /// Update train location (admin/server side)
  Future<void> updateTrainLocation(
      String trainId, double lat, double lng, String nextStation, double speed) async {
    try {
      await _db.child('liveLocation/$trainId').set({
        'lat': lat,
        'lng': lng,
        'nextStation': nextStation,
        'speed': speed,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _toast('Failed to update location', error: true);
    }
  }

  // ════════════════════════════════════════════════════════════════════════════
  // LOST & FOUND
  // ════════════════════════════════════════════════════════════════════════════

  /// Report a lost item
  Future<String?> reportLostItem(Map<String, dynamic> data) async {
    try {
      final ref = _db.child('lostFound').push();
      await ref.set({
        ...data,
        'type': 'lost',
        'userId': uid ?? 'anonymous',
        'status': 'open',
        'createdAt': DateTime.now().toIso8601String(),
      });
      _toast('Lost item reported!');
      return ref.key;
    } catch (e) {
      _toast('Failed to report item. Try again.', error: true);
      return null;
    }
  }

  /// Report a found item
  Future<String?> reportFoundItem(Map<String, dynamic> data) async {
    try {
      final ref = _db.child('lostFound').push();
      await ref.set({
        ...data,
        'type': 'found',
        'userId': uid ?? 'anonymous',
        'status': 'open',
        'createdAt': DateTime.now().toIso8601String(),
      });
      _toast('Found item reported!');
      return ref.key;
    } catch (e) {
      _toast('Failed to report item. Try again.', error: true);
      return null;
    }
  }

  /// Get all found items (type == 'found') as a list
  Future<List<Map<String, dynamic>>> getFoundItems() async {
    try {
      final snap = await _db
          .child('lostFound')
          .orderByChild('type')
          .equalTo('found')
          .get();
      if (!snap.exists || snap.value == null) return [];
      final raw = Map<String, dynamic>.from(snap.value as Map);
      return raw.entries
          .map((e) => Map<String, dynamic>.from(e.value as Map))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Submit a claim
  Future<void> submitClaim(String itemId, Map<String, dynamic> data) async {
    try {
      await _db.child('lostFound/$itemId/claims').push().set({
        ...data,
        'userId': uid ?? 'anonymous',
        'createdAt': DateTime.now().toIso8601String(),
      });
      _toast('Claim submitted!');
    } catch (e) {
      _toast('Failed to submit claim. Try again.', error: true);
    }
  }

  /// Stream all lost & found items
  Stream<List<Map<String, dynamic>>> lostFoundStream({String? type}) {
    final query = type != null
        ? _db.child('lostFound').orderByChild('type').equalTo(type)
        : _db.child('lostFound');
    return query.onValue.map((event) {
      if (!event.snapshot.exists) return [];
      final raw = Map<String, dynamic>.from(event.snapshot.value as Map);
      return raw.entries.map((e) {
        final m = Map<String, dynamic>.from(e.value as Map);
        m['id'] = e.key;
        return m;
      }).toList()
        ..sort((a, b) => (b['createdAt'] as String)
            .compareTo(a['createdAt'] as String));
    });
  }

  // ════════════════════════════════════════════════════════════════════════════
  // RATINGS & REVIEWS
  // ════════════════════════════════════════════════════════════════════════════

  /// Submit a review
  Future<void> submitReview({
    required String trainId,
    required double rating,
    required String comment,
  }) async {
    if (uid == null) {
      _toast('Please login to submit a review', error: true);
      return;
    }
    try {
      await _db.child('reviews/$trainId').push().set({
        'userId': uid,
        'rating': rating,
        'comment': comment,
        'createdAt': DateTime.now().toIso8601String(),
      });
      _toast('Review submitted!');
    } catch (e) {
      _toast('Failed to submit review. Try again.', error: true);
    }
  }

  /// Stream reviews for a train
  Stream<List<Map<String, dynamic>>> reviewsStream(String trainId) {
    return _db.child('reviews/$trainId').onValue.map((event) {
      if (!event.snapshot.exists) return [];
      final raw = Map<String, dynamic>.from(event.snapshot.value as Map);
      return raw.entries.map((e) {
        final m = Map<String, dynamic>.from(e.value as Map);
        m['id'] = e.key;
        return m;
      }).toList();
    });
  }

  // ════════════════════════════════════════════════════════════════════════════
  // EMERGENCIES
  // ════════════════════════════════════════════════════════════════════════════

  /// Get emergency contacts (one-time)
  Future<List<Map<String, dynamic>>> getEmergencyContacts() async {
    try {
      final snap = await _db.child('emergency').get();
      if (!snap.exists || snap.value == null) return [];
      final raw = Map<String, dynamic>.from(snap.value as Map);
      return raw.entries.map((e) {
        final m = Map<String, dynamic>.from(e.value as Map);
        m['id'] = e.key;
        return m;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // ════════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ════════════════════════════════════════════════════════════════════════════

  void _toast(String msg, {bool error = false}) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: error ? const Color(0xFFD32F2F) : const Color(0xFF388E3C),
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  String _authError(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use': return 'Email already registered';
        case 'invalid-email':        return 'Invalid email address';
        case 'weak-password':        return 'Password too weak (min 6 chars)';
        case 'user-not-found':       return 'No account found with this email';
        case 'wrong-password':       return 'Incorrect password';
        case 'too-many-requests':    return 'Too many attempts. Try later';
        default:                     return e.message ?? e.code;
      }
    }
    return e.toString();
  }
}
