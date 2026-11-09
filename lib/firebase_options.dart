import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default Firebase options
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
    apiKey: 'AIzaSyDevKeyJustUSWeb1234567890',
    appId: '1:123456789012:web:abcdef0123456789',
    messagingSenderId: '123456789012',
    projectId: 'justus-dev',
    authDomain: 'justus-dev.firebaseapp.com',
    storageBucket: 'justus-dev.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDevKeyJustUSAndroid1234567890',
    appId: '1:123456789012:android:abcdef0123456789',
    messagingSenderId: '123456789012',
    projectId: 'justus-dev',
    storageBucket: 'justus-dev.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDevKeyJustUSIOS1234567890',
    appId: '1:123456789012:ios:abcdef0123456789',
    messagingSenderId: '123456789012',
    projectId: 'justus-dev',
    storageBucket: 'justus-dev.appspot.com',
    iosBundleId: 'com.justus.justus',
  );
}
