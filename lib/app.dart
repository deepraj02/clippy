import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/helpers/lifecycle_monitor.dart';
import 'core/providers/bootstrap_provider.dart';
import 'core/router/app_router.dart';
import 'generated/l10n.dart';

class AppInit extends ConsumerWidget {
  const AppInit({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final booting = ref.watch(bootstrapProvider);

    return LifecycleMonitor(
      child: booting
          ? const MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          : MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: FlexColorScheme.light(scheme: FlexScheme.indigoM3).toTheme,
              darkTheme:
                  FlexColorScheme.dark(scheme: FlexScheme.indigoM3).toTheme,
              themeMode: ThemeMode.system,
              locale: const Locale.fromSubtags(languageCode: "en"),
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale.fromSubtags(languageCode: "en"),
                Locale.fromSubtags(languageCode: "es"),
                Locale.fromSubtags(languageCode: "fr"),
              ],
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
