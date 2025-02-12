import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:clippy/core/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/clipboard_service.dart';

final clipboardProvider = Provider<ClipboardService>((ref) {
  final service = ClipboardService(
      auth: ref.read(firebaseAuthInstanceProvider),
      firestore: ref.read(firestoreInstanceProvider),
      clipboardWatcher: ref.read(clipboardWatcherProvider));

  service.startClipboardMonitoring();
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

final clipboardWatcherProvider = Provider((ref) {
  return ClipboardWatcher.instance;
});
