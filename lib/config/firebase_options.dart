import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

/// Firebase configuration for Smart Coaster Dashboard.
/// These values are from the existing web project's firebase-config.js.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return android;
    }
  }

  // TODO: After running `flutterfire configure`, replace these with
  // the generated platform-specific values. For now, using the web config
  // as a base — you'll need to register Android/iOS apps in Firebase Console.
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBeEe2ZAH7w18_81X3EAe7WsK858ZZObB0',
    appId: '1:981786199110:web:5fe6e7504976d6678ef647',
    messagingSenderId: '981786199110',
    projectId: 'smart-coaster-c4cb1',
    databaseURL:
        'https://smart-coaster-c4cb1-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'smart-coaster-c4cb1.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBeEe2ZAH7w18_81X3EAe7WsK858ZZObB0',
    appId: '1:981786199110:web:5fe6e7504976d6678ef647',
    messagingSenderId: '981786199110',
    projectId: 'smart-coaster-c4cb1',
    databaseURL:
        'https://smart-coaster-c4cb1-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'smart-coaster-c4cb1.firebasestorage.app',
    iosBundleId: 'com.smartcoaster.dashboard',
  );
}
