import 'package:flutter/material.dart';

class Dts {
  final BuildContext context;
  Dts(this.context);
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
}
