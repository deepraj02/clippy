import 'dart:async';
import 'dart:developer';

import 'package:clipboard_watcher/clipboard_watcher.dart'; // Import the package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';

class ClipboardService with ClipboardListener {
  final List<String> _clipboardHistory = [];
  final StreamController<List<String>> _clipboardStreamController =
      StreamController<List<String>>.broadcast();
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final ClipboardWatcher _clipboardWatcher; // Add ClipboardWatcher

  ClipboardService(
      {required FirebaseAuth auth,
      required FirebaseFirestore firestore,
      required ClipboardWatcher clipboardWatcher}) // Inject ClipboardWatcher
      : _auth = auth,
        _firestore = firestore,
        _clipboardWatcher = clipboardWatcher;

  List<String> get clipboardHistory => _clipboardHistory;
  Stream<List<String>> get clipboardStream => _clipboardStreamController.stream;

  Future<void> startClipboardMonitoring() async {
    _clipboardWatcher.addListener(this);
    _clipboardWatcher.start();
    onClipboardChanged();
  }

  @override
  void onClipboardChanged() async {
    ClipboardData? newClipboardData =
        await Clipboard.getData(Clipboard.kTextPlain);
    if (newClipboardData != null && newClipboardData.text != null) {
      final newText = newClipboardData.text!;
      if (!_clipboardHistory.contains(newText)) {
        _clipboardHistory.insert(0, newText);
        if (!_clipboardStreamController.isClosed) {
          _clipboardStreamController.add(_clipboardHistory);
        }
        await _uploadCopiedData(newText);
      }
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
    _clipboardWatcher.removeListener(this);
    _clipboardWatcher.stop();
    _clipboardStreamController.close();
  }
}
