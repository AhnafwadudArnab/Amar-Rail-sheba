// Firebase Cloud Messaging Service Worker
// Required for background push notifications on web.
// This file must be at the root of the web/ folder.

importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyDmjucqapzZ7RDckE41hkZmY2w9OBSHMKo',
  authDomain: 'railwaysystems-7d372.firebaseapp.com',
  projectId: 'railwaysystems-7d372',
  storageBucket: 'railwaysystems-7d372.firebasestorage.app',
  messagingSenderId: '480104228682',
  appId: '1:480104228682:web:26a0841e7e1a8838cbc3b3',
  databaseURL: 'https://railwaysystems-7d372-default-rtdb.asia-southeast1.firebasedatabase.app',
});

const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage((payload) => {
  const title = payload.notification?.title ?? 'Amar Rail Sheba';
  const body = payload.notification?.body ?? '';
  const options = {
    body,
    icon: '/icons/Icon-192.png',
    badge: '/icons/Icon-192.png',
  };
  return self.registration.showNotification(title, options);
});
