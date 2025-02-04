import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';

class ClipboardService {
  final List<String> _clipboardHistory = [];
  final StreamController<List<String>> _clipboardStreamController =
      StreamController<List<String>>.broadcast();
  Timer? _timer;
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  ClipboardService(
      {required FirebaseAuth auth, required FirebaseFirestore firestore})
      : _auth = auth,
        _firestore = firestore;

  List<String> get clipboardHistory => _clipboardHistory;
  Stream<List<String>> get clipboardStream => _clipboardStreamController.stream;

//TODO: Refactor with Platform Channel to trigger monitoring on clipboard events, instead of using Timer

  Future<void> startClipboardMonitoring() async {
    try {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        final clipboardData = await Clipboard.getData('text/plain');
        if (clipboardData != null &&
            clipboardData.text != null &&
            !_clipboardHistory.contains(clipboardData.text)) {
          _clipboardHistory.insert(0, clipboardData.text!);
          if (!_clipboardStreamController.isClosed) {
            _clipboardStreamController.add(_clipboardHistory);
          }
          await _uploadCopiedData(clipboardData.text!);
        }
      });
    } catch (error) {
      log('Error in startMonitoring: $error');
    }
  }

  Future<Either<String, void>> _uploadCopiedData(String copiedText) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userDoc = _firestore.collection('users').doc(user.uid);
        await userDoc.update({
          'copied': FieldValue.arrayUnion([
            {
              'copy': copiedText,
            }
          ])
        });
        return right(null);
      }
      return left('User not authenticated');
    } catch (error) {
      log('Error in _saveCopiedData: $error');
      return left(error.toString());
    }
  }

  void dispose() {
    _timer?.cancel();
    _clipboardStreamController.close();
  }
}
