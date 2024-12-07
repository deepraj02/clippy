import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  }) : fontSize = 32;

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
