import 'dart:io';

import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final firebaseAuthInstanceProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firestoreInstanceProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn();
});

final authStateProvider = StreamProvider<User?>((ref) {
  final authState = ref.watch(firebaseAuthInstanceProvider).authStateChanges();
  return authState;
});

final clipboardWatcherProvider = Provider<ClipboardWatcher>((ref) {
  return ClipboardWatcher.instance;
});

final backgroundServiceProvider = Provider((ref) async {
  if (Platform.isAndroid) {
    const androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "Your App",
      notificationText: "Running in the background",
      notificationImportance: AndroidNotificationImportance.normal,
      notificationIcon:
          AndroidResource(name: 'background_icon', defType: 'drawable'),
    );

    bool success =
        await FlutterBackground.initialize(androidConfig: androidConfig);
    if (success) {
      await FlutterBackground.enableBackgroundExecution();
    }
  }
});
