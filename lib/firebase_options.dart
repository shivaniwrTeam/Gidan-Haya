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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDirzWOXAZDAKJnUrncyHUF5Qlaa28IZX0',
    appId: '1:726180517727:web:d59b109b83c22e7d0888ea',
    messagingSenderId: '726180517727',
    projectId: 'gidan-haya-f2f33',
    authDomain: 'gidan-haya-f2f33.firebaseapp.com',
    storageBucket: 'gidan-haya-f2f33.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDJ3wJqFcqhb3am_mopHNIhtMGOiZ8Ug4E',
    appId: '1:726180517727:android:9754fae9737176510888ea',
    messagingSenderId: '726180517727',
    projectId: 'gidan-haya-f2f33',
    storageBucket: 'gidan-haya-f2f33.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCWtTSvJBs6OE0mvazJ-YpTNcnLaSVo6Ws',
    appId: '1:726180517727:ios:fdc047a0006ac8860888ea',
    messagingSenderId: '726180517727',
    projectId: 'gidan-haya-f2f33',
    storageBucket: 'gidan-haya-f2f33.appspot.com',
    iosBundleId: 'com.app.gidanhaya',
  );
}
