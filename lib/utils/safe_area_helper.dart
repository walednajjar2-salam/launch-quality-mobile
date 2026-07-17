import 'package:flutter/material.dart';

class SafeAreaHelper {
  /// Status bar height threshold above which a device is considered to have a
  /// notch or Dynamic Island. 24 px corresponds to the standard status bar
  /// height on non-notched devices; anything taller indicates a cut-out.
  static const double _notchThreshold = 24.0;

  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return EdgeInsets.only(
      top: mediaQuery.padding.top,
      bottom: mediaQuery.padding.bottom,
      left: mediaQuery.padding.left,
      right: mediaQuery.padding.right,
    );
  }

  static bool hasNotch(BuildContext context) {
    return MediaQuery.of(context).padding.top > _notchThreshold;
  }

  static double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double getBottomSafeArea(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  static bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }
}
