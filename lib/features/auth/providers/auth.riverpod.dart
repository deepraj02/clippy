import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../state/auth.state.dart';

part 'gen/auth.riverpod.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  AuthState build() {
    return AuthStateInitial();
  }
}
