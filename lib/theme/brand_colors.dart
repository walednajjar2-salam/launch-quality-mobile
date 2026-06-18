import 'package:flutter/material.dart';

/// Launch Quality luxury palette — matches iOS / web identity.
abstract final class BrandColors {
  static const background = Color(0xFF000000);
  static const backgroundElevated = Color(0xFF0A0A0A);
  static const panel = Color(0xFF111111);

  static const gold = Color(0xFF40E0D0);
  static const goldBright = Color(0xFF7FFFD4);
  static const turquoise = Color(0xFF5EEAD4);
  static const tealDeep = Color(0xFF2DD4BF);

  static const textPrimary = Color(0xFFF5F5F5);
  static const textMuted = Color(0xFFA3A3A3);
  static const danger = Color(0xFFF87171);
  static const success = Color(0xFF34D399);

  static const cornerRadius = 28.0;
  static const cardPadding = 18.0;

  static const goldGlow = LinearGradient(
    colors: [Color(0x7340E0D0), Color(0x265EEAD4), Colors.transparent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const glassStroke = LinearGradient(
    colors: [
      Color(0x8C40E0D0),
      Color(0x405EEAD4),
      Color(0x2640E0D0),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
