import 'package:clippy/core/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/clipboard_service.dart';

final clipboardProvider = Provider<ClipboardService>((ref) {
  final service = ClipboardService(
      auth: ref.read(firebaseAuthInstanceProvider),
      firestore: ref.read(firestoreInstanceProvider));

  service.startClipboardMonitoring();
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});
