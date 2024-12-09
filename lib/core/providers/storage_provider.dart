import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/local_storage/services/local_storage.service.dart';

part 'gen/storage_provider.g.dart';

@riverpod
LocalStorage localStorage(LocalStorageRef ref) {
  return LocalStorageService();
}
