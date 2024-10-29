import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  static String route() => "/settings";
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text("Settings Page"),
      ),
    );
  }
}
