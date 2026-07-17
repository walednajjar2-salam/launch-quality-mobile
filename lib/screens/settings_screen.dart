import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/widgets/animated_card.dart';
import '../theme/widgets/luxury_background.dart';
import '../widgets/custom_app_bar.dart';

/// App settings screen with configuration options.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _biometricsEnabled = false;
  bool _autoRefresh = true;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CustomAppBar(
          title: 'الإعدادات',
          showBack: true,
        ),
        body: LuxuryBackground(
          child: SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              children: [
                // Notifications
                _SettingsSection(
                  title: 'الإشعارات',
                  children: [
                    _SwitchTile(
                      icon: Icons.notifications_rounded,
                      label: 'تفعيل الإشعارات',
                      value: _notificationsEnabled,
                      onChanged: (v) =>
                          setState(() => _notificationsEnabled = v),
                    ),
                    _SwitchTile(
                      icon: Icons.volume_up_rounded,
                      label: 'الصوت',
                      value: _soundEnabled,
                      onChanged: _notificationsEnabled
                          ? (v) => setState(() => _soundEnabled = v)
                          : null,
                    ),
                    _SwitchTile(
                      icon: Icons.vibration_rounded,
                      label: 'الاهتزاز',
                      value: _vibrationEnabled,
                      onChanged: _notificationsEnabled
                          ? (v) => setState(() => _vibrationEnabled = v)
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.base),

                // Security
                _SettingsSection(
                  title: 'الأمان',
                  children: [
                    _SwitchTile(
                      icon: Icons.fingerprint_rounded,
                      label: 'تسجيل الدخول البيومتري',
                      value: _biometricsEnabled,
                      onChanged: (v) =>
                          setState(() => _biometricsEnabled = v),
                    ),
                    _ActionTile(
                      icon: Icons.lock_outline_rounded,
                      label: 'تغيير كلمة المرور',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.base),

                // Data
                _SettingsSection(
                  title: 'البيانات',
                  children: [
                    _SwitchTile(
                      icon: Icons.refresh_rounded,
                      label: 'التحديث التلقائي',
                      value: _autoRefresh,
                      onChanged: (v) => setState(() => _autoRefresh = v),
                    ),
                    _ActionTile(
                      icon: Icons.sync_rounded,
                      label: 'مزامنة البيانات الآن',
                      onTap: () => app.refresh(),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.base),

                // Account
                _SettingsSection(
                  title: 'الحساب',
                  children: [
                    _ActionTile(
                      icon: Icons.person_rounded,
                      label: 'الملف الشخصي',
                      onTap: () => context.go('/profile'),
                    ),
                    _ActionTile(
                      icon: Icons.logout_rounded,
                      label: 'تسجيل الخروج',
                      color: AppColors.danger,
                      onTap: () => app.logout(),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.base),

                // About
                _SettingsSection(
                  title: 'حول التطبيق',
                  children: [
                    _InfoTile(
                      icon: Icons.info_outline_rounded,
                      label: 'الإصدار',
                      value: '1.1.0+2',
                    ),
                    _InfoTile(
                      icon: Icons.apartment_rounded,
                      label: 'جودة الانطلاقة للخدمات',
                      value: '',
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
}

// ── Helpers ───────────────────────────────────────────────────────────────

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});
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

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(icon,
          color: onChanged != null ? AppColors.gold : AppColors.textDisabled,
          size: AppSpacing.iconMd),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: onChanged != null
                  ? AppColors.textPrimary
                  : AppColors.textDisabled,
            ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.goldBright,
      dense: true,
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
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
              ?.copyWith(color: c)),
      trailing: Icon(Icons.chevron_left_rounded,
          color: AppColors.textMuted, size: AppSpacing.iconMd),
      onTap: onTap,
      dense: true,
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.gold, size: AppSpacing.iconMd),
      title: Text(label,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.textPrimary)),
      trailing: value.isNotEmpty
          ? Text(value,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textMuted))
          : null,
      dense: true,
    );
  }
}
