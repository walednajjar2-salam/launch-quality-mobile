import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_spacing.dart';
import 'animated_card.dart';

/// Premium KPI card with value, label, icon and optional trend indicator.
class KpiCard extends StatelessWidget {
  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.accent = AppColors.gold,
    this.valueColor,
    this.trend,
    this.trendLabel,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color accent;
  final Color? valueColor;

  /// Positive = up, negative = down, null = no trend arrow.
  final double? trend;
  final String? trendLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trendColor = (trend ?? 0) >= 0 ? AppColors.success : AppColors.danger;
    final trendIcon =
        (trend ?? 0) >= 0 ? Icons.trending_up : Icons.trending_down;

    return AnimatedCard(
      accent: accent,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.cardPaddingTight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icon != null)
                Container(
                  width: AppSpacing.iconXl,
                  height: AppSpacing.iconXl,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Icon(icon, color: accent, size: AppSpacing.iconMd),
                ),
              const Spacer(),
              if (trend != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(trendIcon, color: trendColor, size: 14),
                    const SizedBox(width: 2),
                    Text(
                      trendLabel ?? '${trend!.abs().toStringAsFixed(1)}%',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: trendColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          if (icon != null) const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor ?? AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: accent,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
