import 'package:clippy/features/auth/providers/auth.riverpod.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/app_router.dart';
import 'core/helpers/lifecycle_monitor.dart';

class AppInit extends ConsumerWidget {
  const AppInit({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    ref.listen(authProvider, (prev, next) {
      router.refresh(); 
    });
    return LifecycleMonitor(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: FlexColorScheme.light(scheme: FlexScheme.indigoM3).toTheme,
        darkTheme: FlexColorScheme.dark(scheme: FlexScheme.indigoM3).toTheme,
        themeMode: ThemeMode.system,
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
        // home: const Scaffold(
        //   body: AuthPage(),
        // ),
      ),
    );
  }
}
