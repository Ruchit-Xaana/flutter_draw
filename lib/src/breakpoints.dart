import 'package:flutter/material.dart';

class AppBreakpoints {
  static const double desktop = 640.0;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < desktop;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktop;
}
