import 'package:flutter/material.dart';

import '../brand_colors.dart';

/// Standard Material card (custom glass/luxury theme removed).
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
    final content = Stack(
      children: [
        Positioned(
          left: 0,
          top: 12,
          bottom: 12,
          child: Container(
            width: 3,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
        Padding(
          padding: padding ?? const EdgeInsets.all(BrandColors.cardPadding),
          child: child,
        ),
      ],
    );

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: onTap == null
          ? content
          : InkWell(
              onTap: onTap,
              child: content,
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
    final cs = Theme.of(context).colorScheme;
    return GlassCard(
      accent: accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) Icon(icon, color: accent, size: 22),
          if (icon != null) const SizedBox(height: 10),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? cs.onSurface,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
