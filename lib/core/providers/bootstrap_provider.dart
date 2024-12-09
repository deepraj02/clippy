import 'dart:developer';

import 'package:clippy/core/providers/storage_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gen/bootstrap_provider.g.dart';

@riverpod
class Bootstrap extends _$Bootstrap {
  @override
  bool build() {
    Future.delayed(const Duration(seconds: 1), () => bootstrapApp());
    return true;
  }

  Future<void> bootstrapApp() async {
    try {
      await ref.read(localStorageProvider).init();
      state = false;
      log("BOOTSTRAPPED", name: "BOOTSTRAP");
    } catch (e) {
      log("BOOTSTRAP ERROR: $e", name: "BOOTSTRAP");
    }
  }
}
