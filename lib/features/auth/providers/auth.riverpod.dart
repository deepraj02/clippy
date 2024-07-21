import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../services/auth.service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    auth: ref.read(firebaseInstanceProvider),
    firestore: ref.read(firestoreInstanceProvider),
    googleSignIn: ref.read(googleSignInProvider),
  );
});
