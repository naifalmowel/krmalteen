// Generated file for Firebase setup template.
// To connect to your real live Firebase project, run `flutterfire configure` CLI.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
      apiKey: "AIzaSyC-lV554nWFlrR4pPwvNETyvc7FehxhMBA",
      authDomain: "krmalteenz.firebaseapp.com",
      projectId: "krmalteenz",
      storageBucket: "krmalteenz.firebasestorage.app",
      messagingSenderId: "87696190597",
      appId: "1:87696190597:web:3525c83fb8237c56af4dec",
      measurementId: "G-8G2CT3MD1D"
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'DEMO-API-KEY-ANDROID',
    appId: '1:100000000000:android:krmaltenandroid',
    messagingSenderId: '100000000000',
    projectId: 'krm-alteen-restaurant',
    storageBucket: 'krm-alteen-restaurant.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'DEMO-API-KEY-IOS',
    appId: '1:100000000000:ios:krmaltenios',
    messagingSenderId: '100000000000',
    projectId: 'krm-alteen-restaurant',
    storageBucket: 'krm-alteen-restaurant.appspot.com',
    iosBundleId: 'com.krmalten.restaurant',
  );
}
