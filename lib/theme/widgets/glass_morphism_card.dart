import 'dart:ui';
import 'package:flutter/material.dart';

class GlassmorphismCard extends StatelessWidget {
  const GlassmorphismCard({
    super.key,
    required this.child,
    this.blur = 10,
    this.opacity = 0.2,
    this.borderRadius,
  });

  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: opacity),
            borderRadius: borderRadius ?? BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
