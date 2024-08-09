import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

class UserService {
  final FirebaseAuth _auth;

  UserService({required FirebaseAuth auth}) : _auth = auth;

  Future<Either<String, T?>> checkUserSession<T extends User>() async {
    try {
      final result = _auth.currentUser;
      if (result == null) {
        return left("No User Session Found");
      }
      return right(result as T);
    } catch (e, st) {
      log("USER SERVICE ERROR : $e\n", error: e, stackTrace: st);
      return left("No User Session Found");
    }
  }
}
