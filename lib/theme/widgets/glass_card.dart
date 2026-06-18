import 'dart:ui';

import 'package:flutter/material.dart';

import '../brand_colors.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.accent = BrandColors.gold,
    this.padding,
    this.onTap,
  });

  final Widget child;
  final Color accent;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final body = ClipRRect(
      borderRadius: BorderRadius.circular(BrandColors.cornerRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                BrandColors.panel.withValues(alpha: 0.92),
                BrandColors.backgroundElevated.withValues(alpha: 0.88),
              ],
            ),
            borderRadius: BorderRadius.circular(BrandColors.cornerRadius),
            border: Border.all(color: accent.withValues(alpha: 0.28)),
            boxShadow: [
              BoxShadow(
                color: BrandColors.gold.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: BrandColors.turquoise.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 12,
                bottom: 12,
                child: Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Padding(
                padding: padding ?? const EdgeInsets.all(BrandColors.cardPadding),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );

    if (onTap == null) return body;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(BrandColors.cornerRadius),
        child: body,
      ),
    );
  }
}

class KpiTile extends StatelessWidget {
  const KpiTile({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.accent = BrandColors.gold,
    this.valueColor,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color accent;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      accent: accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Icon(icon, color: accent, size: 22),
          if (icon != null) const SizedBox(height: 10),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? BrandColors.textPrimary,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: BrandColors.goldBright,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
