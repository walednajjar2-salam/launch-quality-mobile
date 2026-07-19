import 'package:flutter/material.dart';

import '../brand_colors.dart';

class CircularProgressRing extends StatelessWidget {
  const CircularProgressRing({
    super.key,
    required this.progress,
    this.size = 96,
    this.strokeWidth = 10,
    this.accent = BrandColors.gold,
    this.label,
  });

  final double progress;
  final double size;
  final double strokeWidth;
  final Color accent;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final brand = BrandColors.of(context);
    final value = (progress.clamp(0, 100)) / 100;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: strokeWidth,
              backgroundColor: accent.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(accent),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${progress.round()}%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: brand.textPrimary,
                    ),
              ),
              if (label != null)
                Text(
                  label!,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: brand.textMuted,
                      ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
