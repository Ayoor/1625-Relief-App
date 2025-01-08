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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD3ti9aPG6amtJ1yM9mcP5qikOzq25KHYk',
    appId: '1:109576140067:android:963436acd949af9c8bc896',
    messagingSenderId: '109576140067',
    projectId: 'relief-513c5',
    databaseURL: 'https://relief-513c5-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'relief-513c5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDjmzkmAPVBojxlmE-RwWoghKjKWzaRlVE',
    appId: '1:109576140067:ios:d46e38f7771325e18bc896',
    messagingSenderId: '109576140067',
    projectId: 'relief-513c5',
    databaseURL: 'https://relief-513c5-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'relief-513c5.appspot.com',
    iosBundleId: 'com.ayodele.tech.reliefApp',
  );
}