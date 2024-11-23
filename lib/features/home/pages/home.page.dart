import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/firebase_providers.dart';

class HomePage extends ConsumerWidget {
  static String route() => "/home";
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(authStateProvider.select(
      (value) => value.valueOrNull?.displayName,
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Clippy",
        ),
        actions: [
          IconButton(
              onPressed: () => context.push("/settings"),
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Welcome, ${name?.split(" ")[0] ?? 'Guest'}"),
        ],
      ),
    );
  }
}
