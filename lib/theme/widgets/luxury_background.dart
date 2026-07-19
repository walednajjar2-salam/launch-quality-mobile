import 'package:flutter/material.dart';

/// Plain system background (custom luxury theme removed).
class LuxuryBackground extends StatelessWidget {
  const LuxuryBackground({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: child,
    );
  }
}
