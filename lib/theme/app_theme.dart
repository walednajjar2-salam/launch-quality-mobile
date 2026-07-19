import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'brand_colors.dart';
import 'widgets/glass_card.dart';

export 'brand_colors.dart';
export 'widgets/circular_progress_ring.dart';
export 'widgets/glass_card.dart';
export 'widgets/luxury_background.dart';

class AppTheme {
  static ThemeData light() {
    final scheme = BrandScheme.light;
    final textTheme = GoogleFonts.tajawalTextTheme(
      ThemeData(brightness: Brightness.light).textTheme,
    ).apply(
      bodyColor: scheme.textPrimary,
      displayColor: scheme.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: scheme.background,
      extensions: const [BrandScheme.light],
      colorScheme: ColorScheme.light(
        primary: scheme.goldBright,
        secondary: scheme.turquoise,
        surface: scheme.panel,
        error: BrandColors.danger,
        onPrimary: Colors.white,
        onSurface: scheme.textPrimary,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.goldBright,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        titleTextStyle: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: scheme.goldBright,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.panel.withValues(alpha: 0.98),
        indicatorColor: scheme.gold.withValues(alpha: 0.18),
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStatePropertyAll(
          textTheme.labelSmall?.copyWith(color: scheme.textMuted),
        ),
        iconTheme: WidgetStatePropertyAll(
          IconThemeData(color: scheme.goldBright),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: scheme.panel.withValues(alpha: 0.95),
        indicatorColor: scheme.gold.withValues(alpha: 0.18),
        selectedIconTheme: IconThemeData(color: scheme.goldBright),
        unselectedIconTheme: IconThemeData(color: scheme.textMuted),
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: scheme.goldBright,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: scheme.textMuted,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.black.withValues(alpha: 0.04),
        labelStyle: TextStyle(color: scheme.textMuted),
        hintStyle: TextStyle(color: scheme.textMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.gold.withValues(alpha: 0.25)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.gold.withValues(alpha: 0.18)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.goldBright, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.goldBright,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.gold.withValues(alpha: 0.15),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.panel,
        contentTextStyle: textTheme.bodyMedium,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.gold.withValues(alpha: 0.25)),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final scheme = BrandScheme.dark;
    final textTheme = GoogleFonts.tajawalTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    ).apply(
      bodyColor: scheme.textPrimary,
      displayColor: scheme.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: scheme.background,
      extensions: const [BrandScheme.dark],
      colorScheme: ColorScheme.dark(
        primary: scheme.goldBright,
        secondary: scheme.turquoise,
        surface: scheme.panel,
        error: BrandColors.danger,
        onPrimary: Colors.black,
        onSurface: scheme.textPrimary,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.goldBright,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        titleTextStyle: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: scheme.goldBright,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.panel.withValues(alpha: 0.98),
        indicatorColor: scheme.gold.withValues(alpha: 0.18),
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStatePropertyAll(
          textTheme.labelSmall?.copyWith(color: scheme.textMuted),
        ),
        iconTheme: WidgetStatePropertyAll(
          IconThemeData(color: scheme.goldBright),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: scheme.panel.withValues(alpha: 0.95),
        indicatorColor: scheme.gold.withValues(alpha: 0.18),
        selectedIconTheme: IconThemeData(color: scheme.goldBright),
        unselectedIconTheme: IconThemeData(color: scheme.textMuted),
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: scheme.goldBright,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: scheme.textMuted,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        labelStyle: TextStyle(color: scheme.textMuted),
        hintStyle: TextStyle(color: scheme.textMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.gold.withValues(alpha: 0.25)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.gold.withValues(alpha: 0.18)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.goldBright, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.goldBright,
          foregroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.gold.withValues(alpha: 0.15),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.panel,
        contentTextStyle: textTheme.bodyMedium,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.gold.withValues(alpha: 0.25)),
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
    final brand = BrandColors.of(context);
    return Center(
      child: GlassCard(
        accent: brand.turquoise,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: brand.textMuted),
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
    final brand = BrandColors.of(context);
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(Icons.search, color: brand.gold),
      ),
    );
  }
}
