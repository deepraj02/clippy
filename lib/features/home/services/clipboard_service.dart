import 'dart:async';

import 'package:flutter/services.dart';

class ClipboardService {
  final List<String> _clipboardHistory = [];
  final StreamController<List<String>> _clipboardStreamController =
      StreamController<List<String>>.broadcast();
  Timer? _timer;

  List<String> get clipboardHistory => _clipboardHistory;
  Stream<List<String>> get clipboardStream => _clipboardStreamController.stream;

  void startMonitoring() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final clipboardData = await Clipboard.getData('text/plain');
      if (clipboardData != null &&
          clipboardData.text != null &&
          !_clipboardHistory.contains(clipboardData.text)) {
        _clipboardHistory.insert(
            0, clipboardData.text!); 
        if (!_clipboardStreamController.isClosed) {
          _clipboardStreamController.add(_clipboardHistory);
        }
      }
    });
  }

  void dispose() {
    _timer?.cancel();
    _clipboardStreamController.close();
  }
}
