import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../../firebase_options.dart';

class FirebaseService {
  static bool _initialized = false;
  static bool get isInitialized => _initialized;

  static Future<bool> initialize() async {
    if (_initialized) return true;
    try {
      if (Firebase.apps.isNotEmpty) {
        _initialized = true;
        return true;
      }
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _initialized = true;
      if (kDebugMode) {
        print('Firebase initialized successfully.');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Firebase initialization notice: $e');
      }
      _initialized = false;
      return false;
    }
  }
}
