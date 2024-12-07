import 'package:flutter/material.dart';

import '../../../core/helpers/widgets/clippy_text.dart';
import '../../../generated/l10n.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.booting,
  });

  final bool booting;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                ClippyText.description(
                  text: AppLocalization.of(context).getStarted,
                ),
              ],
            ),
    );
  }
}
