import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class HapticFeedbackHelper {
  static Future<void> lightTap() async {
    try {
      await HapticFeedback.lightImpact();
    } catch (e) {
      debugPrint('Haptic feedback not available');
    }
  }

  static Future<void> mediumTap() async {
    try {
      await HapticFeedback.mediumImpact();
    } catch (e) {
      debugPrint('Haptic feedback not available');
    }
  }

  static Future<void> heavyTap() async {
    try {
      await HapticFeedback.heavyImpact();
    } catch (e) {
      debugPrint('Haptic feedback not available');
    }
  }

  static Future<void> success() async {
    try {
      await HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 100));
      await HapticFeedback.lightImpact();
    } catch (e) {
      debugPrint('Haptic feedback not available');
    }
  }

  static Future<void> error() async {
    try {
      for (int i = 0; i < 3; i++) {
        await HapticFeedback.lightImpact();
        await Future.delayed(const Duration(milliseconds: 100));
      }
    } catch (e) {
      debugPrint('Haptic feedback not available');
    }
  }

  static Future<void> selection() async {
    try {
      await HapticFeedback.selectionClick();
    } catch (e) {
      debugPrint('Haptic feedback not available');
    }
  }
}
