import 'package:flutter/material.dart';

/// Launch Quality brand accents + adaptive surface/text scheme.
abstract final class BrandColors {
  static const gold = Color(0xFF0F766E);
  static const goldBright = Color(0xFF0D9488);
  static const turquoise = Color(0xFF14B8A6);
  static const tealDeep = Color(0xFF0F766E);

  static const danger = Color(0xFFDC2626);
  static const success = Color(0xFF059669);

  static const cornerRadius = 28.0;
  static const cardPadding = 18.0;

  /// Default (light) surface aliases — prefer [of] inside widgets.
  static const background = Color(0xFFFDFBF7);
  static const backgroundElevated = Color(0xFFFFFFFF);
  static const panel = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1C1917);
  static const textMuted = Color(0xFF78716C);

  static const goldGlow = LinearGradient(
    colors: [Color(0x330D9488), Color(0x1414B8A6), Colors.transparent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const glassStroke = LinearGradient(
    colors: [
      Color(0x660D9488),
      Color(0x3314B8A6),
      Color(0x1A0D9488),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Resolve surface/text colors for the active brightness.
  static BrandScheme of(BuildContext context) {
    final extension = Theme.of(context).extension<BrandScheme>();
    if (extension != null) return extension;
    return Theme.of(context).brightness == Brightness.dark
        ? BrandScheme.dark
        : BrandScheme.light;
  }
}

@immutable
class BrandScheme extends ThemeExtension<BrandScheme> {
  const BrandScheme({
    required this.background,
    required this.backgroundElevated,
    required this.panel,
    required this.textPrimary,
    required this.textMuted,
    required this.gold,
    required this.goldBright,
    required this.turquoise,
  });

  final Color background;
  final Color backgroundElevated;
  final Color panel;
  final Color textPrimary;
  final Color textMuted;
  final Color gold;
  final Color goldBright;
  final Color turquoise;

  static const light = BrandScheme(
    background: Color(0xFFFDFBF7),
    backgroundElevated: Color(0xFFFFFFFF),
    panel: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF1C1917),
    textMuted: Color(0xFF78716C),
    gold: Color(0xFF0F766E),
    goldBright: Color(0xFF0D9488),
    turquoise: Color(0xFF14B8A6),
  );

  static const dark = BrandScheme(
    background: Color(0xFF000000),
    backgroundElevated: Color(0xFF0A0A0A),
    panel: Color(0xFF111111),
    textPrimary: Color(0xFFF5F5F5),
    textMuted: Color(0xFFA3A3A3),
    gold: Color(0xFF40E0D0),
    goldBright: Color(0xFF7FFFD4),
    turquoise: Color(0xFF5EEAD4),
  );

  @override
  BrandScheme copyWith({
    Color? background,
    Color? backgroundElevated,
    Color? panel,
    Color? textPrimary,
    Color? textMuted,
    Color? gold,
    Color? goldBright,
    Color? turquoise,
  }) {
    return BrandScheme(
      background: background ?? this.background,
      backgroundElevated: backgroundElevated ?? this.backgroundElevated,
      panel: panel ?? this.panel,
      textPrimary: textPrimary ?? this.textPrimary,
      textMuted: textMuted ?? this.textMuted,
      gold: gold ?? this.gold,
      goldBright: goldBright ?? this.goldBright,
      turquoise: turquoise ?? this.turquoise,
    );
  }

  @override
  BrandScheme lerp(ThemeExtension<BrandScheme>? other, double t) {
    if (other is! BrandScheme) return this;
    return BrandScheme(
      background: Color.lerp(background, other.background, t)!,
      backgroundElevated:
          Color.lerp(backgroundElevated, other.backgroundElevated, t)!,
      panel: Color.lerp(panel, other.panel, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      goldBright: Color.lerp(goldBright, other.goldBright, t)!,
      turquoise: Color.lerp(turquoise, other.turquoise, t)!,
    );
  }
}
