import 'package:flutter/material.dart';

import '../brand_colors.dart';

class LuxuryBackground extends StatelessWidget {
  const LuxuryBackground({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                BrandColors.background,
                BrandColors.backgroundElevated,
                BrandColors.panel,
              ],
            ),
          ),
        ),
        Positioned(
          top: -80,
          left: -40,
          child: _glow(BrandColors.gold.withValues(alpha: 0.14), 280),
        ),
        Positioned(
          top: -60,
          right: -20,
          child: _glow(BrandColors.turquoise.withValues(alpha: 0.10), 240),
        ),
        Center(
          child: Opacity(
            opacity: 0.06,
            child: Image.asset(
              'assets/logo.png',
              width: 360,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        ),
        if (child != null) child!,
      ],
    );
  }

  Widget _glow(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
      ),
    );
  }
}
