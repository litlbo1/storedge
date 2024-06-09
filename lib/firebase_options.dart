// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD7HSrD97VKDXamFSvH0qJa7p5NEeM16rQ',
    appId: '1:979379693109:web:1d8c2c4501b0eb4fbbf37c',
    messagingSenderId: '979379693109',
    projectId: 'storedge-3515a',
    authDomain: 'storedge-3515a.firebaseapp.com',
    storageBucket: 'storedge-3515a.appspot.com',
    measurementId: 'G-V88WDJ5M2X',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDM-nskhW7UdUt29x1Cqrza8N7aGHHTxw0',
    appId: '1:979379693109:android:211dd1366a0b225abbf37c',
    messagingSenderId: '979379693109',
    projectId: 'storedge-3515a',
    storageBucket: 'storedge-3515a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBshVTxpTtdlUEStGfcPOwO5kwP4nNraaQ',
    appId: '1:979379693109:ios:d18da1d85fc40a78bbf37c',
    messagingSenderId: '979379693109',
    projectId: 'storedge-3515a',
    storageBucket: 'storedge-3515a.appspot.com',
    iosBundleId: 'com.example.storedge',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBshVTxpTtdlUEStGfcPOwO5kwP4nNraaQ',
    appId: '1:979379693109:ios:d18da1d85fc40a78bbf37c',
    messagingSenderId: '979379693109',
    projectId: 'storedge-3515a',
    storageBucket: 'storedge-3515a.appspot.com',
    iosBundleId: 'com.example.storedge',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD7HSrD97VKDXamFSvH0qJa7p5NEeM16rQ',
    appId: '1:979379693109:web:330ec225c75b1f24bbf37c',
    messagingSenderId: '979379693109',
    projectId: 'storedge-3515a',
    authDomain: 'storedge-3515a.firebaseapp.com',
    storageBucket: 'storedge-3515a.appspot.com',
    measurementId: 'G-KX9KX7SLWN',
  );
}