import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/pages/auth.page.dart';
import '../features/home/pages/home.page.dart';

part 'app_router.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: "/login",
    routes: [
      GoRoute(
        path: "/login",
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: "/home",
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}
