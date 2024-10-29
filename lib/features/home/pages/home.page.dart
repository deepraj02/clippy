import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/firebase_providers.dart';
import '../../auth/providers/auth.riverpod.dart';
import '../../auth/state/auth.state.dart';

class HomePage extends ConsumerWidget {
  static String route() => "/home";
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(authStateProvider.select(
      (value) => value.valueOrNull?.displayName,
    ));
    final newState = ref.read(authProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => context.push("/settings"),
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Wellcome, $name. This is your homepage."),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ref.read(authProvider.notifier).logout();
                  if (newState is AuthStateInitial && context.mounted) {
                    // return context.refresh();
                    return context.replace("/login");
                  }
                } catch (e) {
                  log(e.toString());
                }
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
