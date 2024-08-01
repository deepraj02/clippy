import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthService(
      {required FirebaseAuth auth,
      required FirebaseFirestore firestore,
      required GoogleSignIn googleSignIn})
      : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  Future<Either<String, User>> signup(
      {required String email, required String password}) async {
    try {
      final response = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return right(response.user!);
    } on FirebaseAuthException catch (e) {
      return left(e.message ?? 'Failed to Signup.');
    }
  }

  @Deprecated("Divide in Chunks")
  Future<Either<String, User?>> signInWithGoogleAndRegisterDatabase() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          await _firestore.collection('users').doc(user.uid).set({
            'email': user.email,
            'name': user.displayName,
            'photoUrl': user.photoURL,
            'createdAt': Timestamp.now(),
          });
        }
      }
      log("UserCred:  ${userCredential.user!.uid}\n");
      log("USER : $user\n");
      log(" AUTH CurrentUser : ${_auth.currentUser!}\n");
      return right(user!);
    } catch (e) {
      log(e.toString());
      return left(e.toString());
    }
  }

  Future<Either<String, void>> logout() async {
    try {
      await _googleSignIn.disconnect();
      _auth.signOut();
      log("LOGOUT : ${_auth.currentUser}\n");
      return right(null);
    } catch (e) {
      log("LOGOUT ERROR : $e\n");
      return left(e.toString());
    }
  }

  Either<String, User?> currentUser() {
    try {
      return right(_auth.currentUser);
    } catch (e, st) {
      log("CURRENT USER ERROR : $e\n $st\n");
      return left(e.toString());
    }
  }
}
