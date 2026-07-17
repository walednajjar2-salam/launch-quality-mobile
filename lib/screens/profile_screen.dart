import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/widgets/animated_card.dart';
import '../theme/widgets/luxury_background.dart';
import '../widgets/custom_app_bar.dart';

/// User profile screen with account information and personal settings.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final user = app.user;
    final userName = user?.name ?? 'المستخدم';
    final userRole = user?.roleLabel ?? 'مدير النظام';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: 'الملف الشخصي',
          showBack: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: AppColors.goldBright),
              onPressed: () {},
            ),
          ],
        ),
        body: LuxuryBackground(
          child: SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              children: [
                // Avatar & name
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.gold, width: 2.5),
                        ),
                        child: Center(
                          child: Text(
                            _initials(userName),
                            style:
                                Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: AppColors.goldBright,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        userName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.15),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusFull),
                          border: Border.all(
                              color: AppColors.gold.withValues(alpha: 0.35)),
                        ),
                        child: Text(
                          userRole,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppColors.goldBright,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Account info
                _ProfileSection(
                  title: 'معلومات الحساب',
                  children: [
                    _ProfileTile(
                      icon: Icons.person_rounded,
                      label: 'الاسم الكامل',
                      value: userName,
                    ),
                    _ProfileTile(
                      icon: Icons.badge_rounded,
                      label: 'الدور الوظيفي',
                      value: userRole,
                    ),
                    _ProfileTile(
                      icon: Icons.circle,
                      label: 'حالة الحساب',
                      value: 'نشط',
                      valueColor: AppColors.success,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.base),

                // Actions
                _ProfileSection(
                  title: 'الإجراءات',
                  children: [
                    _ProfileActionTile(
                      icon: Icons.lock_outline_rounded,
                      label: 'تغيير كلمة المرور',
                      onTap: () {},
                    ),
                    _ProfileActionTile(
                      icon: Icons.settings_rounded,
                      label: 'الإعدادات',
                      onTap: () => context.go('/settings'),
                    ),
                    _ProfileActionTile(
                      icon: Icons.logout_rounded,
                      label: 'تسجيل الخروج',
                      color: AppColors.danger,
                      onTap: () => app.logout(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}';
    if (parts[0].isNotEmpty) return parts[0][0];
    return '؟';
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.goldBright,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AnimatedCard(
          accent: AppColors.gold,
          padding: EdgeInsets.zero,
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.gold, size: AppSpacing.iconMd),
      title: Text(label,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: AppColors.textMuted)),
      subtitle: Text(
        value,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: valueColor ?? AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
      ),
      dense: true,
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  const _ProfileActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textPrimary;
    return ListTile(
      leading: Icon(icon, color: c, size: AppSpacing.iconMd),
      title: Text(label,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: c, fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.chevron_left_rounded,
          color: AppColors.textMuted, size: AppSpacing.iconMd),
      onTap: onTap,
      dense: true,
    );
  }
}
