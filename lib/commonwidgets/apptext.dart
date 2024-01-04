import 'package:employeeblacklistdata/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  final String text;
  final double size;
  final dynamic color;
  final dynamic weight;
  final dynamic align;
  const AppText(
      {super.key,
      required this.text,
      required this.size,
      this.color,
      this.weight,
      this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.cabin(
        color: color ?? textColor,
        fontSize: size,
        fontWeight: weight ?? FontWeight.w400,
      ),
      textAlign: align,
    );
  }
}
