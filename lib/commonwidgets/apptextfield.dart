import 'package:employeeblacklistdata/res/colors.dart';
import 'package:employeeblacklistdata/res/size.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final dynamic obsecure;
  final dynamic maxLines;
  const AppTextField(
      {super.key,
      required this.controller,
      required this.hint,
      this.obsecure,
      this.maxLines});

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dts(context).width > 650 ? 400 : Dts(context).width * 0.7,
      child: TextField(
        maxLines: widget.maxLines,
        obscureText: widget.obsecure ?? false,
        controller: widget.controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme)),
          labelText: widget.hint,
          labelStyle: GoogleFonts.cabin(
              color: Colors.white.withOpacity(0.7), fontSize: 14),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme)),
        ),
        style: GoogleFonts.cabin(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
