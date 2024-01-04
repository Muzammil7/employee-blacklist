import 'package:employeeblacklistdata/commonwidgets/apptext.dart';
import 'package:employeeblacklistdata/res/colors.dart';
import 'package:flutter/cupertino.dart';

class AppButton extends StatefulWidget {
  final String text;
  final dynamic ontap;
  final dynamic color;
  final dynamic textColor;
  final dynamic size;
  final dynamic padding;
  const AppButton(
      {super.key,
      required this.text,
      required this.ontap,
      this.color,
      this.textColor,
      this.size,
      this.padding});

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding:
          EdgeInsets.fromLTRB(widget.padding ?? 30, 0, widget.padding ?? 30, 0),
      onPressed: widget.ontap,
      color: widget.color ?? theme,
      child: AppText(
        text: widget.text,
        size: widget.size ?? 14,
        color: widget.textColor,
        weight: FontWeight.w700,
      ),
    );
  }
}
