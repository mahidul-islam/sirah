// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAI162YyDOnDrv3nMGmjN6arCvODpoBF8g',
    appId: '1:863324622340:web:5c5c218c7b3968f0382f51',
    messagingSenderId: '863324622340',
    projectId: 'islamic-history-timeline',
    authDomain: 'islamic-history-timeline.firebaseapp.com',
    storageBucket: 'islamic-history-timeline.appspot.com',
    measurementId: 'G-5TW1F07JRF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAu3prJjayJJwPT9wW-4yj1vjCkfHCUM1A',
    appId: '1:863324622340:android:af1d548ed40c4ac9382f51',
    messagingSenderId: '863324622340',
    projectId: 'islamic-history-timeline',
    storageBucket: 'islamic-history-timeline.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDt3Tb-J-umiNp4ACK12sET31PBO3mCOu0',
    appId: '1:863324622340:ios:140924e65a69d879382f51',
    messagingSenderId: '863324622340',
    projectId: 'islamic-history-timeline',
    storageBucket: 'islamic-history-timeline.appspot.com',
    iosClientId: '863324622340-24b6hieqcfcirqjp9lhpjuq7981264q4.apps.googleusercontent.com',
    iosBundleId: 'com.arrijal.sirah',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDt3Tb-J-umiNp4ACK12sET31PBO3mCOu0',
    appId: '1:863324622340:ios:140924e65a69d879382f51',
    messagingSenderId: '863324622340',
    projectId: 'islamic-history-timeline',
    storageBucket: 'islamic-history-timeline.appspot.com',
    iosClientId: '863324622340-24b6hieqcfcirqjp9lhpjuq7981264q4.apps.googleusercontent.com',
    iosBundleId: 'com.arrijal.sirah',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAI162YyDOnDrv3nMGmjN6arCvODpoBF8g',
    appId: '1:863324622340:web:a7f38088cd735adf382f51',
    messagingSenderId: '863324622340',
    projectId: 'islamic-history-timeline',
    authDomain: 'islamic-history-timeline.firebaseapp.com',
    storageBucket: 'islamic-history-timeline.appspot.com',
    measurementId: 'G-QMRCHSRZWB',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyAI162YyDOnDrv3nMGmjN6arCvODpoBF8g',
    appId: '1:863324622340:web:b1fb46e70cc8debd382f51',
    messagingSenderId: '863324622340',
    projectId: 'islamic-history-timeline',
    authDomain: 'islamic-history-timeline.firebaseapp.com',
    storageBucket: 'islamic-history-timeline.appspot.com',
    measurementId: 'G-LEM3CQNDQ1',
  );
}
