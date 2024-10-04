import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gen/bootstrap_provider.g.dart';

@riverpod
class Bootstrap extends _$Bootstrap {
  @override
  bool build() {
    bootstrapApp();
    return true;
  }

  Future<void> bootstrapApp() async {
    state = false;
  }
}
