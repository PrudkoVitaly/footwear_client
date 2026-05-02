import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (Platform.isAndroid) {
      return android;
    }
    if (Platform.isIOS) {
      return ios;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not configured for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB05VCZcvMhHuXcBLSEImaxR3X-UEl0tn4',
    appId: '1:311944290195:android:44fe6f66d7495806ef9266',
    messagingSenderId: '311944290195',
    projectId: 'footwear-50d88',
    storageBucket: 'footwear-50d88.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB05VCZcvMhHuXcBLSEImaxR3X-UEl0tn4',
    appId: '1:311944290195:ios:4c0e7d487b0c66faef9266',
    messagingSenderId: '311944290195',
    projectId: 'footwear-50d88',
    storageBucket: 'footwear-50d88.firebasestorage.app',
  );
}
