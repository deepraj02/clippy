import 'package:clippy/features/settings/pages/settings.page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/pages/auth.page.dart';
import '../../features/home/pages/home.page.dart';
import '../providers/firebase_providers.dart';

part 'app_router.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  final navigatorKey = GlobalKey<NavigatorState>();
  final authState = ref.watch(authStateProvider.stream);
  final authStatus = ref.read(firebaseAuthInstanceProvider);

  return GoRouter(
    navigatorKey: navigatorKey,
    debugLogDiagnostics: true,
    initialLocation: AuthPage.route(),
    routes: [
      GoRoute(
        path: AuthPage.route(),
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: HomePage.route(),
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: SettingsPage.route(),
        builder: (context, state) => const SettingsPage(),
      ),
    ],
    redirect: (context, state) {
      final loggedIn = authStatus.currentUser != null;
      final loggingIn = state.matchedLocation == AuthPage.route();
      if (!loggedIn && !loggingIn) {
        return AuthPage.route();
      }
      if (loggedIn && loggingIn) {
        return HomePage.route();
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authState),
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<User?> stream) {
    stream.listen((_) => notifyListeners());
  }
}
