import 'dart:developer';

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
    //await Env.init();
    state = false;
    log("BOOTSTRAPED", name: "BOOTSTRAP");
  }
}
