import 'package:firebase_auth/firebase_auth.dart';

sealed class AuthState {
  const AuthState();
}

class AuthStateInitial extends AuthState {}

class AuthStateLoading extends AuthState {}

class AuthStateSuccess extends AuthState {
  final User user;

  AuthStateSuccess({required this.user});
}

class AuthStateFailure extends AuthState {
  final String message;

  AuthStateFailure(this.message);
}
