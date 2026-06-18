import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'brand_colors.dart';
import 'widgets/glass_card.dart';

export 'brand_colors.dart';
export 'widgets/circular_progress_ring.dart';
export 'widgets/glass_card.dart';
export 'widgets/luxury_background.dart';

class AppTheme {
  static ThemeData dark() {
    final textTheme = GoogleFonts.tajawalTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    ).apply(
      bodyColor: BrandColors.textPrimary,
      displayColor: BrandColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: BrandColors.background,
      colorScheme: const ColorScheme.dark(
        primary: BrandColors.goldBright,
        secondary: BrandColors.turquoise,
        surface: BrandColors.panel,
        error: BrandColors.danger,
        onPrimary: Colors.black,
        onSurface: BrandColors.textPrimary,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: BrandColors.goldBright,
        elevation: 0,
        titleTextStyle: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: BrandColors.goldBright,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: BrandColors.panel.withValues(alpha: 0.95),
        indicatorColor: BrandColors.gold.withValues(alpha: 0.18),
        labelTextStyle: WidgetStatePropertyAll(
          textTheme.labelSmall?.copyWith(color: BrandColors.textMuted),
        ),
        iconTheme: WidgetStatePropertyAll(
          IconThemeData(color: BrandColors.goldBright),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: BrandColors.panel.withValues(alpha: 0.95),
        indicatorColor: BrandColors.gold.withValues(alpha: 0.18),
        selectedIconTheme: const IconThemeData(color: BrandColors.goldBright),
        unselectedIconTheme: IconThemeData(color: BrandColors.textMuted),
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: BrandColors.goldBright,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: BrandColors.textMuted,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        labelStyle: const TextStyle(color: BrandColors.textMuted),
        hintStyle: const TextStyle(color: BrandColors.textMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: BrandColors.gold.withValues(alpha: 0.25)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: BrandColors.gold.withValues(alpha: 0.18)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: BrandColors.goldBright, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: BrandColors.goldBright,
          foregroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: BrandColors.gold.withValues(alpha: 0.15),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: BrandColors.panel,
        contentTextStyle: textTheme.bodyMedium,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: BrandColors.gold.withValues(alpha: 0.25)),
        ),
      ),
    );
  }
}

String money(num? value) {
  final n = NumberFormat('#,##0.00', 'en_US').format(value ?? 0);
  return '$n OMR';
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GlassCard(
        accent: BrandColors.turquoise,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: BrandColors.textMuted),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.hint,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search, color: BrandColors.gold),
      ),
    );
  }
}
