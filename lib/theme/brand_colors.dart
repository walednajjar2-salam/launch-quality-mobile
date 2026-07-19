import 'package:flutter/material.dart';

/// Simple accent aliases mapped to Material defaults (no custom luxury theme).
/// Prefer [Theme.of(context).colorScheme] in new UI.
abstract final class BrandColors {
  static const gold = Color(0xFF00639A);
  static const goldBright = Color(0xFF00639A);
  static const turquoise = Color(0xFF006874);
  static const tealDeep = Color(0xFF004F58);

  static const danger = Color(0xFFBA1A1A);
  static const success = Color(0xFF146C2E);

  static const cornerRadius = 12.0;
  static const cardPadding = 16.0;

  static const background = Color(0xFFF8F9FF);
  static const backgroundElevated = Color(0xFFFFFFFF);
  static const panel = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF191C20);
  static const textMuted = Color(0xFF43474E);

  static BrandScheme of(BuildContext context) {
    final extension = Theme.of(context).extension<BrandScheme>();
    if (extension != null) return extension;
    final cs = Theme.of(context).colorScheme;
    return BrandScheme(
      background: cs.surface,
      backgroundElevated: cs.surfaceContainerHighest,
      panel: cs.surfaceContainerLow,
      textPrimary: cs.onSurface,
      textMuted: cs.onSurfaceVariant,
      gold: cs.primary,
      goldBright: cs.primary,
      turquoise: cs.secondary,
    );
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

  static BrandScheme fromColorScheme(ColorScheme cs) {
    return BrandScheme(
      background: cs.surface,
      backgroundElevated: cs.surfaceContainerHighest,
      panel: cs.surfaceContainerLow,
      textPrimary: cs.onSurface,
      textMuted: cs.onSurfaceVariant,
      gold: cs.primary,
      goldBright: cs.primary,
      turquoise: cs.secondary,
    );
  }

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
