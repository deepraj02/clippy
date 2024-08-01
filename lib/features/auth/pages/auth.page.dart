import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth.service.riverpod.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  Future<void> _signInWithGoogle() async {
    try {
      await ref.read(authServiceProvider).signInWithGoogleAndRegisterDatabase();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
           
            Positioned(
              top: MediaQuery.sizeOf(context).height * 0.4,
              left: 20,
              child: const Text('Let\'s\nget started'),
            ),
            Positioned(
              top: MediaQuery.sizeOf(context).height * 0.58,
              left: 20,
              child: const Text('Everything start from here'),
            ),
            Positioned(
              top: MediaQuery.sizeOf(context).height * 0.68,
              left: 40,
              child: ElevatedButton(
                onPressed: _signInWithGoogle,
                child: const Text('Sign in with Google'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
