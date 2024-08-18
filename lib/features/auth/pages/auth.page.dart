import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth.riverpod.dart';
import '../state/auth.state.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});
  static String route() => '/login';
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

  @override
  Widget build(BuildContext context) {
    final newState = ref.read(authProvider);
    return Scaffold(
      body: Consumer(
        builder: (context, ref, _) {
          if (booting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final state = ref.watch(authProvider);

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Builder(builder: (context) {
                  switch (state) {
                    case AuthStateInitial():
                      return const Text("Initial");
                    case AuthStateLoading():
                      return const CircularProgressIndicator();
                    case AuthStateSuccess():
                      return Text("User: ${state.user.email}");
                    default:
                      return const Text("Initial");
                  }
                }),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await ref
                          .read(authProvider.notifier)
                          .continueWithGoogle();
                      if (newState is AuthStateSuccess && context.mounted) {
                        context.push("/home");
                      }
                    } on Exception catch (e) {
                      dev.log(e.toString());
                    }
                  },
                  child: const Text("Sign In with Google"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
