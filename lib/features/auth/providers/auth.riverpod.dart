import 'package:clippy/features/auth/providers/auth.service.riverpod.dart';
import 'package:clippy/features/user/providers/user.service.riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../state/auth.state.dart';

part 'gen/auth.riverpod.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  AuthState build() {
    init();
    print("1");
    return AuthStateLoading();
  }

  Future<void> signup({required String email, required String password}) async {
    state = AuthStateLoading();
    final response = await ref
        .read(authServiceProvider)
        .signup(email: email, password: password);
    state = response.fold(
      (error) => AuthStateFailure(error),
      (response) => AuthStateSuccess(user: response),
    );
  }

  Future<void> continueWithGoogle() async {
    state = AuthStateLoading();
    final response = await ref
        .read(authServiceProvider)
        .signInWithGoogleAndRegisterDatabase();
    state = response.fold(
      (error) => AuthStateFailure(error),
      (response) => AuthStateSuccess(user: response!),
    );
  }

  Future<void> logout() async {
    state = AuthStateLoading();
    final response = await ref.read(authServiceProvider).logout();
    state = response.fold(
      (error) => state = AuthStateFailure(error),
      (response) => state = AuthStateInitial(),
    );
  }

  void setUser(User user) {
    state = AuthStateSuccess(user: user);
  }

  Future<void> init() async {
    print("2");
    final result = await ref.read(userServiceProvider).checkUserSession();
    print("3");
    result.fold(
      (l) => state = AuthStateFailure(l),
      (r) {
        if (r == null) {
          state = AuthStateFailure("No User Session Found");
        } else {
          state = AuthStateSuccess(user: r);
        }
      },
    );
  }

}
