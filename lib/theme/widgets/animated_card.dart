import 'dart:ui';

import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_spacing.dart';

/// A premium animated glass card with hover/tap scale effect.
class AnimatedCard extends StatefulWidget {
  const AnimatedCard({
    super.key,
    required this.child,
    this.accent = AppColors.gold,
    this.padding,
    this.onTap,
    this.animateOnHover = true,
  });

  final Widget child;
  final Color accent;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool animateOnHover;

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _controller.forward();
  void _onTapUp(_) => _controller.reverse();
  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    Widget card = ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.panel.withValues(alpha: 0.92),
                AppColors.backgroundElevated.withValues(alpha: 0.88),
              ],
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            border: Border.all(
              color: widget.accent.withValues(alpha: _hovered ? 0.45 : 0.28),
            ),
            boxShadow: AppColors.goldShadow,
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
                    color: widget.accent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Padding(
                padding: widget.padding ??
                    const EdgeInsets.all(AppSpacing.cardPadding),
                child: widget.child,
              ),
            ],
          ),
        ),
      ),
    );

    if (widget.onTap == null) {
      return AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: card,
      );
    }

    return MouseRegion(
      onEnter: widget.animateOnHover
          ? (_) => setState(() => _hovered = true)
          : null,
      onExit: widget.animateOnHover
          ? (_) => setState(() => _hovered = false)
          : null,
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _scale,
          builder: (_, child) =>
              Transform.scale(scale: _scale.value, child: child),
          child: card,
        ),
      ),
    );
  }
}
