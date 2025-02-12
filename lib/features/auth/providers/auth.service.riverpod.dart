import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/global_providers.dart';
import '../services/auth.service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    auth: ref.read(firebaseAuthInstanceProvider),
    firestore: ref.read(firestoreInstanceProvider),
    googleSignIn: ref.read(googleSignInProvider),
  );
});
