import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../services/user.service.dart';

final userServiceProvider = Provider<UserService>((ref) {
  return UserService(
    auth: ref.watch(firebaseAuthInstanceProvider),
  );
});
