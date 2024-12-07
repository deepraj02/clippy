import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/helpers/widgets/clippy_text.dart';
import '../providers/auth.riverpod.dart';
import '../state/auth.state.dart';
import '../widgets/auth_button.dart';

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

    Future<void> handleAuth(AuthState newState, BuildContext context) async {
      setState(() {
        booting = true;
      });
      try {
        await ref.read(authProvider.notifier).continueWithGoogle();
        booting = true;
        if (newState is AuthStateSuccess && context.mounted) {
          context.push("/home");
        }
        setState(() {
          booting = false;
        });
      } on Exception catch (e) {
        dev.log(e.toString());
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFCEEACA),
      body: Stack(
        children: [
          Align(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ClippyText.headline(
                  text: "Share Clipboard\n across Devices",
                  color: Colors.black,
                )
                    .animate()
                    .slideY(
                      begin: 1,
                      end: 0,
                      delay: const Duration(milliseconds: 500),
                    )
                    .moveY(
                      begin: 0,
                      end: 1,
                    ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.sizeOf(context).height * .05),
              child: InkWell(
                splashColor: Colors.white,
                customBorder: const StadiumBorder(),
                onTap: () async {
                  await handleAuth(newState, context);
                },
                child: AuthButton(booting: booting)
                    .animate()
                    .slideX(delay: const Duration(seconds: 1))
                    .fadeIn(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
