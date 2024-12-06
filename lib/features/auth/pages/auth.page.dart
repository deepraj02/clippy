import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../generated/l10n.dart';
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
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.sizeOf(context).height * .05),
              child: InkWell(
                splashColor: Colors.white,
                customBorder: const StadiumBorder(),
                onTap: () async {
                  setState(() {
                    booting = true;
                  });
                  try {
                    await ref.read(authProvider.notifier).continueWithGoogle();
                    booting = true;
                    if (newState is AuthStateSuccess && context.mounted) {
                      context.push("/home");
                    }
                  } on Exception catch (e) {
                    dev.log(e.toString());
                  } finally {
                    setState(() {
                      booting = false;
                    });
                  }
                },
                child: Container(
                  height: MediaQuery.sizeOf(context).height * .09,
                  width: MediaQuery.sizeOf(context).width * .46,
                  decoration: const ShapeDecoration(
                    color: Color(0xFF0A0A0A),
                    shape: StadiumBorder(),
                  ),
                  child: booting
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClippyText.headline(
                              text: AppLocalization.of(context).getStarted,
                            ),
                          ],
                        ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ClippyText extends StatelessWidget {
  const ClippyText({
    super.key,
    required this.text,
    required this.fontSize,
    this.fontWeight,
    this.color,
  });
  final String text;
  final double fontSize;
  final FontWeight? fontWeight;
  final Color? color;

  const ClippyText.headline({
    super.key,
    required this.text,
    this.fontWeight,
    this.color,
  }) : fontSize = 16;

  const ClippyText.description({
    super.key,
    required this.text,
    this.fontWeight,
    this.color,
  }) : fontSize = 16;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.sora(
          color: color ?? Colors.white,
          fontSize: fontSize,
          fontWeight: fontWeight ?? FontWeight.normal,
        ));
  }
}
