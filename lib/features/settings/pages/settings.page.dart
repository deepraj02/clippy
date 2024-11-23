import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/providers/auth.riverpod.dart';
import '../../auth/state/auth.state.dart';

class SettingsPage extends ConsumerWidget {
  static String route() => "/settings";
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newState = ref.read(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              await ref.read(authProvider.notifier).logout();
              if (newState is AuthStateInitial && context.mounted) {
                //return context.refresh();
                context.pop();
                return context.replace("/login");
              }
            } catch (e) {
              log(e.toString());
            }
          },
          child: const Text("Logout"),
        ),
      ),
    );
  }
}
