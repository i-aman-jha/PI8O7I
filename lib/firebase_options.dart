import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: "AIzaSyAwBvttxReGvirqRW-BmQONMADXkld4iZ0",
        authDomain: "assignment-df1d3.firebaseapp.com",
        projectId: "assignment-df1d3",
        storageBucket: "assignment-df1d3.firebasestorage.app",
        messagingSenderId: "823995165154",
        appId: "1:823995165154:web:9b2f184d14fb18f7c8f1bb",
        measurementId: "G-N9BPG2T52J",
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const FirebaseOptions(
          apiKey: "AIzaSyAwBvttxReGvirqRW-BmQONMADXkld4iZ0",
          appId: "1:823995165154:android:0b542e519fa2880cc8f1bb",
          messagingSenderId: "823995165154",
          projectId: "assignment-df1d3",
          storageBucket: "assignment-df1d3.firebasestorage.app",
        );
      case TargetPlatform.iOS:
        throw UnsupportedError("iOS is not supported");
      case TargetPlatform.macOS:
        throw UnsupportedError("macOS is not supported");
      case TargetPlatform.windows:
        throw UnsupportedError("Windows is not supported");
      case TargetPlatform.linux:
        throw UnsupportedError("Linux is not supported");
      default:
        throw UnsupportedError("Unknown platform");
    }
  }
}
