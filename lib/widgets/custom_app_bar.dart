import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Premium professional app bar with gold accent and optional actions.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.showBack = false,
    this.elevation = 0,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final bool showBack;
  final double elevation;

  @override
  Size get preferredSize => const Size.fromHeight(AppSpacing.appBarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: AppSpacing.appBarHeight,
      decoration: BoxDecoration(
        color: AppColors.panel.withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(
            color: AppColors.gold.withValues(alpha: 0.18),
            width: AppSpacing.dividerThickness,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
          child: Row(
            children: [
              // Leading
              if (showBack)
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  color: AppColors.goldBright,
                  onPressed: () => Navigator.of(context).maybePop(),
                  iconSize: AppSpacing.iconMd,
                )
              else if (leading != null)
                leading!
              else
                const SizedBox(width: AppSpacing.sm),

              // Title
              if (centerTitle) const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: centerTitle
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.goldBright,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                ],
              ),
              if (centerTitle) const Spacer(),

              // Actions
              if (actions != null)
                ...actions!
              else
                const SizedBox(width: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}
