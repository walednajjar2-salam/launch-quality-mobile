import 'package:flutter/material.dart';

abstract final class LayoutBreakpoints {
  static const phoneMax = 600.0;
  static const tabletMax = 900.0;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < phoneMax;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= phoneMax && width < tabletMax;
  }

  static bool isCompact(BuildContext context) =>
      isMobile(context);

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletMax;

  static int gridColumns(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 1200) return 4;
    if (w >= tabletMax) return 3;
    if (w >= phoneMax) return 2;
    return 2;
  }
}
