import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => const FirebaseOptions(
        apiKey: 'dev-key',
        appId: '1:000000000:android:dev',
        messagingSenderId: '000000000',
        projectId: 'calling-app-dev',
      );
}
