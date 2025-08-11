import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 600;
  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 1200;
  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1200;

  static double contentWidth(BuildContext context) {
    if (isDesktop(context)) {
      return 800;
    } else if (isTablet(context)) {
      return 600;
    } else {
      return MediaQuery.of(context).size.width * 0.9;
    }
  }

  static double contentPadding(BuildContext context) {
    if (isDesktop(context)) {
      return 32;
    } else if (isTablet(context)) {
      return 24;
    } else {
      return 50;
    }
  }
}
