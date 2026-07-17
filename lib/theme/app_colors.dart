import 'package:flutter/material.dart';

/// Extended premium color palette for Phase 5 UI/UX system.
/// Extends [BrandColors] with Gold/Navy scheme and additional semantic colors.
abstract final class AppColors {
  // ── Core palette ──────────────────────────────────────────────────────────
  static const background = Color(0xFF000000);
  static const backgroundElevated = Color(0xFF0A0A0A);
  static const panel = Color(0xFF111111);
  static const surface = Color(0xFF1A1A2E);

  // ── Gold accent ───────────────────────────────────────────────────────────
  static const gold = Color(0xFFD4AF37);
  static const goldBright = Color(0xFFFFD700);
  static const goldMuted = Color(0xFF9B7D2B);
  static const goldGlow = Color(0x40D4AF37);

  // ── Navy accent ───────────────────────────────────────────────────────────
  static const navy = Color(0xFF0A1628);
  static const navyLight = Color(0xFF152547);
  static const navyMid = Color(0xFF1E3A5F);
  static const navyBright = Color(0xFF2563EB);

  // ── Teal / Turquoise (legacy compatibility) ───────────────────────────────
  static const turquoise = Color(0xFF5EEAD4);
  static const tealDeep = Color(0xFF2DD4BF);

  // ── Text ──────────────────────────────────────────────────────────────────
  static const textPrimary = Color(0xFFF5F5F5);
  static const textSecondary = Color(0xFFCBD5E1);
  static const textMuted = Color(0xFFA3A3A3);
  static const textDisabled = Color(0xFF525252);

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const danger = Color(0xFFF87171);
  static const success = Color(0xFF34D399);
  static const warning = Color(0xFFFBBF24);
  static const info = Color(0xFF60A5FA);

  // ── Gradients ─────────────────────────────────────────────────────────────
  static const goldGradient = LinearGradient(
    colors: [Color(0xFFD4AF37), Color(0xFFFFD700), Color(0xFFB8960C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const navyGradient = LinearGradient(
    colors: [Color(0xFF0A1628), Color(0xFF1E3A5F)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const premiumGradient = LinearGradient(
    colors: [Color(0xFF0A1628), Color(0xFF1E3A5F), Color(0xFF2D1B69)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const glassGradient = LinearGradient(
    colors: [Color(0x1AD4AF37), Color(0x0AFFD700), Colors.transparent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const glassStroke = LinearGradient(
    colors: [
      Color(0x8CD4AF37),
      Color(0x40FFD700),
      Color(0x26D4AF37),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Overlay & shadows ─────────────────────────────────────────────────────
  static const overlayDark = Color(0x80000000);
  static const overlayLight = Color(0x1AFFFFFF);

  static List<BoxShadow> get goldShadow => [
        BoxShadow(
          color: gold.withValues(alpha: 0.18),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
        BoxShadow(
          color: goldBright.withValues(alpha: 0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get navyShadow => [
        BoxShadow(
          color: navy.withValues(alpha: 0.4),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];
}
