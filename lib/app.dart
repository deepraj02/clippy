import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/helpers/lifecycle_monitor.dart';

class AppInit extends ConsumerWidget {
  const AppInit({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LifecycleMonitor(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: FlexColorScheme.light(scheme: FlexScheme.indigoM3).toTheme,
        darkTheme: FlexColorScheme.dark(scheme: FlexScheme.indigoM3).toTheme,
        themeMode: ThemeMode.system,
        title: 'Clippy',
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Clippy"),
          ),
          body: Center(
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Update Text'),
            ),
          ),
        ),
      ),
    );
  }
}
