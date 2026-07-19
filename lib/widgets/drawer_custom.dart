import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// A custom drawer menu item.
class DrawerMenuItem {
  const DrawerMenuItem({
    required this.icon,
    required this.label,
    required this.route,
    this.badge,
  });

  final IconData icon;
  final String label;
  final String route;
  final String? badge;
}

/// Premium custom navigation drawer with gold/navy theme.
class DrawerCustom extends StatelessWidget {
  const DrawerCustom({
    super.key,
    required this.userName,
    required this.userRole,
    required this.userInitials,
    required this.currentRoute,
    required this.items,
    this.onItemTap,
    this.onLogout,
    this.avatarColor,
  });

  final String userName;
  final String userRole;
  final String userInitials;
  final String currentRoute;
  final List<DrawerMenuItem> items;
  final void Function(DrawerMenuItem)? onItemTap;
  final VoidCallback? onLogout;
  final Color? avatarColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      width: AppSpacing.drawerWidth,
      backgroundColor: AppColors.panel,
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.xxxl,
              AppSpacing.xl,
              AppSpacing.xl,
            ),
            decoration: const BoxDecoration(
              gradient: AppColors.navyGradient,
              border: Border(
                bottom: BorderSide(
                  color: Color(0x40D4AF37),
                  width: AppSpacing.dividerThickness,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gold border on logo
                Container(
                  width: AppSpacing.avatarLg,
                  height: AppSpacing.avatarLg,
                  decoration: BoxDecoration(
                    color: (avatarColor ?? AppColors.gold).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.gold,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      userInitials,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.goldBright,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  userName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Text(
                    userRole,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.goldBright,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Menu items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final selected = currentRoute == item.route;

                return _DrawerTile(
                  item: item,
                  selected: selected,
                  onTap: () {
                    Navigator.of(context).pop();
                    onItemTap?.call(item);
                  },
                );
              },
            ),
          ),

          // Footer / logout
          if (onLogout != null)
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.gold.withValues(alpha: 0.15),
                  ),
                ),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.danger,
                  size: AppSpacing.iconMd,
                ),
                title: Text(
                  'تسجيل الخروج',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.danger,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  onLogout?.call();
                },
              ),
            ),

          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final DrawerMenuItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.gold.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: selected
            ? Border.all(color: AppColors.gold.withValues(alpha: 0.25))
            : null,
      ),
      child: ListTile(
        leading: Icon(
          item.icon,
          color: selected ? AppColors.goldBright : AppColors.textMuted,
          size: AppSpacing.iconMd,
        ),
        title: Text(
          item.label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: selected ? AppColors.goldBright : AppColors.textPrimary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        trailing: item.badge != null
            ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Text(
                  item.badge!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
    );
  }
}
