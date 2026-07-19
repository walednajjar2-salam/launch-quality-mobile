import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// A custom bottom navigation bar item definition.
class BottomNavItem {
  const BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

/// Premium custom bottom navigation bar with gold indicator.
class BottomNavigationBarCustom extends StatelessWidget {
  const BottomNavigationBarCustom({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  final List<BottomNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: AppSpacing.bottomNavHeight,
      decoration: BoxDecoration(
        color: AppColors.panel.withValues(alpha: 0.96),
        border: Border(
          top: BorderSide(
            color: AppColors.gold.withValues(alpha: 0.18),
            width: AppSpacing.dividerThickness,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final selected = index == selectedIndex;

          return Expanded(
            child: InkWell(
              onTap: () => onItemSelected(index),
              customBorder: const CircleBorder(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.gold.withValues(alpha: 0.15)
                            : Colors.transparent,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      child: Icon(
                        selected ? item.activeIcon : item.icon,
                        color: selected
                            ? AppColors.goldBright
                            : AppColors.textMuted,
                        size: AppSpacing.iconMd,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: selected
                            ? AppColors.goldBright
                            : AppColors.textMuted,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
