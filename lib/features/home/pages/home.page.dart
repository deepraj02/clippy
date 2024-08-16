import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/providers/auth.riverpod.dart';
import '../../auth/state/auth.state.dart';

class HomePage extends ConsumerWidget {
  static String route() => "/home";
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newState = ref.read(authProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  await ref.read(authProvider.notifier).logout();
                  if(newState is AuthStateInitial && context.mounted) return context.pop();
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
