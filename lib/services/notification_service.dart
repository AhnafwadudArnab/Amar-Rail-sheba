import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Handles FCM push notifications.
/// Call [init] once after Firebase.initializeApp().
class NotificationService {
  static final NotificationService _i = NotificationService._();
  factory NotificationService() => _i;
  NotificationService._();

  final _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    // Request permission (iOS + Android 13+; web shows browser prompt)
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // On web, FCM uses VAPID key — set it here if you have one
    // final token = await _fcm.getToken(vapidKey: 'YOUR_VAPID_KEY');
    final token = await _fcm.getToken();
    debugPrint('FCM Token: $token');
    // TODO: Save token to Firebase users/{uid}/fcmToken

    // Foreground messages — show as toast
    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      final title = msg.notification?.title ?? '';
      final body = msg.notification?.body ?? '';
      if (title.isNotEmpty || body.isNotEmpty) {
        // fluttertoast doesn't work on web — use SnackBar fallback
        if (kIsWeb) {
          // Web: handled via service worker / browser notification
          // The notification will appear as a browser notification when app is in background
          debugPrint('FCM (web foreground): $title — $body');
        } else {
          Fluttertoast.showToast(
            msg: '$title\n$body'.trim(),
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: const Color(0xFF1A3A6B),
          );
        }
      }
    });

    // Background tap — app was in background and user tapped notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage msg) {
      // TODO: Navigate to relevant screen based on msg.data['type']
      // e.g. if msg.data['type'] == 'booking' → navigate to My Tickets
    });
  }

  /// Call this after a booking is confirmed to notify the user.
  /// In production this should be triggered server-side via Firebase Functions.
  /// This is a client-side placeholder.
  static Map<String, String> bookingConfirmedPayload({
    required String bookingId,
    required String from,
    required String to,
    required String date,
  }) {
    return {
      'type': 'booking',
      'bookingId': bookingId,
      'title': 'Booking Confirmed!',
      'body': '$from → $to on $date',
    };
  }
}
