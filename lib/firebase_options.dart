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
    apiKey: 'AIzaSyA8j9kYIbJCsJfZ7ufY7iJka0s7ql7dfjk',
    appId: '1:428961685781:web:d02df637d1dac70ff4c91c',
    messagingSenderId: '428961685781',
    projectId: 'two-f-project-todo',
    authDomain: 'two-f-project-todo.firebaseapp.com',
    storageBucket: 'two-f-project-todo.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBq9v7ybj90MFDeGiY1EsB_yk75gCYC_no',
    appId: '1:428961685781:android:4b8d4488a84f6d26f4c91c',
    messagingSenderId: '428961685781',
    projectId: 'two-f-project-todo',
    storageBucket: 'two-f-project-todo.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAb38YM8uOCg2XMSlcOMCATlw9y37YBUxM',
    appId: '1:428961685781:ios:70ebcabea825421af4c91c',
    messagingSenderId: '428961685781',
    projectId: 'two-f-project-todo',
    storageBucket: 'two-f-project-todo.appspot.com',
    iosBundleId: 'com.twofcapital.twofcapital',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAb38YM8uOCg2XMSlcOMCATlw9y37YBUxM',
    appId: '1:428961685781:ios:70ebcabea825421af4c91c',
    messagingSenderId: '428961685781',
    projectId: 'two-f-project-todo',
    storageBucket: 'two-f-project-todo.appspot.com',
    iosBundleId: 'com.twofcapital.twofcapital',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA8j9kYIbJCsJfZ7ufY7iJka0s7ql7dfjk',
    appId: '1:428961685781:web:d1b2d6af6f9414d1f4c91c',
    messagingSenderId: '428961685781',
    projectId: 'two-f-project-todo',
    authDomain: 'two-f-project-todo.firebaseapp.com',
    storageBucket: 'two-f-project-todo.appspot.com',
  );
}
