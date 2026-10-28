import 'package:flutter/material.dart';

class ResponsiveLayout {
  ResponsiveLayout._();

  static const double mobileBreakpoint = 600;
  static const double desktopBreakpoint = 960;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktopBreakpoint;

  static int getGridColumnCount(double width) {
    if (width < 600) {
      return 2;
    } else if (width < 900) {
      return 3;
    } else if (width < 1200) {
      return 4;
    } else {
      return 5;
    }
  }

  static double getCardAspectRatio(double width) {
    if (width < 360) {
      return 0.58;
    } else if (width < 600) {
      return 0.62;
    } else if (width < 900) {
      return 0.65;
    } else {
      return 0.70;
    }
  }
}
