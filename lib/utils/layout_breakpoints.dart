import 'package:flutter/material.dart';

abstract final class LayoutBreakpoints {
  static const phoneMax = 600.0;
  static const tabletMax = 900.0;

  static bool isCompact(BuildContext context) =>
      MediaQuery.sizeOf(context).width < phoneMax;

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
