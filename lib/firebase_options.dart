import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.windows:
        return web; // fallback for windows desktop
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDmjucqapzZ7RDckE41hkZmY2w9OBSHMKo',
    appId: '1:480104228682:web:26a0841e7e1a8838cbc3b3',
    messagingSenderId: '480104228682',
    projectId: 'railwaysystems-7d372',
    storageBucket: 'railwaysystems-7d372.firebasestorage.app',
    databaseURL: 'https://railwaysystems-7d372-default-rtdb.asia-southeast1.firebasedatabase.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDmjucqapzZ7RDckE41hkZmY2w9OBSHMKo',
    appId: '1:480104228682:android:26a0841e7e1a8838cbc3b3',
    messagingSenderId: '480104228682',
    projectId: 'railwaysystems-7d372',
    storageBucket: 'railwaysystems-7d372.firebasestorage.app',
    databaseURL: 'https://railwaysystems-7d372-default-rtdb.asia-southeast1.firebasedatabase.app',
  );
}
