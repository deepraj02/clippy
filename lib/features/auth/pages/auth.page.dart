import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth.riverpod.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  bool booting = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    await ref.read(authProvider.notifier).init();
    setState(() {
      booting = false;
    });
  }
  // Future<void> _signInWithGoogle() async {
  //   try {
  //     await ref.read(authServiceProvider).signInWithGoogleAndRegisterDatabase();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, _) {
          if (booting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await ref.read(authProvider.notifier).continueWithGoogle();
                  },
                  child: const Text("Sign In with Google"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await ref.read(authProvider.notifier).logout();
                  },
                  child: const Text("Logout"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
