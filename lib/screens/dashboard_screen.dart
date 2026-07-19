import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/widgets/animated_card.dart';
import '../theme/widgets/kpi_card.dart';
import '../theme/widgets/luxury_background.dart';
import '../widgets/bottom_navigation_bar_custom.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/drawer_custom.dart';

/// Comprehensive main dashboard screen with KPIs, activity feed, and quick
/// actions. This screen is the top-level dashboard accessible at /dashboard.
class PremiumDashboardScreen extends StatefulWidget {
  const PremiumDashboardScreen({super.key});

  @override
  State<PremiumDashboardScreen> createState() => _PremiumDashboardScreenState();
}

class _PremiumDashboardScreenState extends State<PremiumDashboardScreen> {
  int _selectedIndex = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static const _navItems = [
    BottomNavItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard_rounded,
      label: 'الرئيسية',
    ),
    BottomNavItem(
      icon: Icons.analytics_outlined,
      activeIcon: Icons.analytics_rounded,
      label: 'التحليلات',
    ),
    BottomNavItem(
      icon: Icons.notifications_outlined,
      activeIcon: Icons.notifications_rounded,
      label: 'الإشعارات',
    ),
    BottomNavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'الحساب',
    ),
  ];

  static const _drawerItems = [
    DrawerMenuItem(
      icon: Icons.dashboard_rounded,
      label: 'لوحة التحكم',
      route: '/dashboard',
    ),
    DrawerMenuItem(
      icon: Icons.analytics_rounded,
      label: 'التحليلات',
      route: '/analytics',
    ),
    DrawerMenuItem(
      icon: Icons.bar_chart_rounded,
      label: 'التقارير',
      route: '/reports',
    ),
    DrawerMenuItem(
      icon: Icons.notifications_rounded,
      label: 'الإشعارات',
      route: '/notifications',
      badge: '3',
    ),
    DrawerMenuItem(
      icon: Icons.settings_rounded,
      label: 'الإعدادات',
      route: '/settings',
    ),
    DrawerMenuItem(
      icon: Icons.person_rounded,
      label: 'الملف الشخصي',
      route: '/profile',
    ),
  ];

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 1:
        context.go('/analytics');
      case 2:
        context.go('/notifications');
      case 3:
        context.go('/profile');
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final bootstrap = app.bootstrap;
    final kpis = bootstrap?.kpis ?? {};
    final userName = app.user?.name ?? 'المستخدم';
    final userRole = app.user?.roleLabel ?? 'مدير النظام';
    final initials = _initials(userName);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: 'لوحة التحكم',
          subtitle: _formattedDate(),
          leading: IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppColors.goldBright),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          actions: [
            IconButton(
              icon: Stack(
                children: [
                  const Icon(Icons.notifications_outlined,
                      color: AppColors.goldBright),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.danger,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () => context.go('/notifications'),
            ),
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.sm),
              child: GestureDetector(
                onTap: () => context.go('/profile'),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.gold.withValues(alpha: 0.2),
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: AppColors.goldBright,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
        ),
        drawer: DrawerCustom(
          userName: userName,
          userRole: userRole,
          userInitials: initials,
          currentRoute: '/dashboard',
          items: _drawerItems,
          onItemTap: (item) => context.go(item.route),
          onLogout: () => app.logout(),
        ),
        body: LuxuryBackground(
          child: SafeArea(
            top: false,
            child: RefreshIndicator(
              color: AppColors.gold,
              onRefresh: () => app.refresh(),
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                children: [
                  // ── Welcome ─────────────────────────────────────────────
                  _WelcomeBanner(userName: userName, userRole: userRole),
                  const SizedBox(height: AppSpacing.sectionSpacing),

                  // ── KPI grid ─────────────────────────────────────────────
                  _SectionHeader(title: 'المؤشرات الرئيسية'),
                  const SizedBox(height: AppSpacing.md),
                  _KpiGrid(kpis: kpis),
                  const SizedBox(height: AppSpacing.sectionSpacing),

                  // ── Quick actions ─────────────────────────────────────────
                  _SectionHeader(title: 'الإجراءات السريعة'),
                  const SizedBox(height: AppSpacing.md),
                  _QuickActions(),
                  const SizedBox(height: AppSpacing.sectionSpacing),

                  // ── Activity feed ─────────────────────────────────────────
                  _SectionHeader(title: 'آخر النشاطات'),
                  const SizedBox(height: AppSpacing.md),
                  const _ActivityFeed(),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBarCustom(
          items: _navItems,
          selectedIndex: _selectedIndex,
          onItemSelected: _onNavTap,
        ),
      ),
    );
  }

  String _formattedDate() {
    final now = DateTime.now();
    return DateFormat('d/M/yyyy').format(now);
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}';
    if (parts[0].isNotEmpty) return parts[0][0];
    return '؟';
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.goldBright,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  const _WelcomeBanner({required this.userName, required this.userRole});
  final String userName;
  final String userRole;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedCard(
      accent: AppColors.gold,
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.gold.withValues(alpha: 0.2),
            child: Text(
              _initials(userName),
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.goldBright,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحباً، $userName',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  userRole,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'نشط',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
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

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.kpis});
  final Map<String, dynamic> kpis;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##0.00', 'en_US');
    String money(dynamic v) =>
        '${fmt.format((v is num) ? v : double.tryParse('$v') ?? 0)} OMR';

    final tiles = [
      (
        label: 'الإيرادات',
        value: money(kpis['income']),
        icon: Icons.trending_up_rounded,
        accent: AppColors.success,
        trend: 8.5,
      ),
      (
        label: 'المصروفات',
        value: money(kpis['expense']),
        icon: Icons.trending_down_rounded,
        accent: AppColors.danger,
        trend: -3.2,
      ),
      (
        label: 'الصافي',
        value: money(kpis['net']),
        icon: Icons.account_balance_wallet_rounded,
        accent: AppColors.gold,
        trend: 12.0,
      ),
      (
        label: 'الإشغال',
        value: '${kpis['occupancy'] ?? 0}%',
        icon: Icons.home_rounded,
        accent: AppColors.info,
        trend: 2.1,
      ),
      (
        label: 'المتأخرات',
        value: money(kpis['overdue']),
        icon: Icons.warning_amber_rounded,
        accent: AppColors.warning,
        trend: -5.0,
      ),
      (
        label: 'صيانة مفتوحة',
        value: '${kpis['maintenance'] ?? 0}',
        icon: Icons.build_rounded,
        accent: AppColors.turquoise,
        trend: null,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: AppSpacing.kpiTileAspect,
      ),
      itemCount: tiles.length,
      itemBuilder: (context, i) {
        final t = tiles[i];
        return KpiCard(
          label: t.label,
          value: t.value,
          icon: t.icon,
          accent: t.accent,
          trend: t.trend,
        );
      },
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final actions = [
      (icon: Icons.add_circle_outline_rounded, label: 'إضافة عقار', color: AppColors.gold),
      (icon: Icons.person_add_rounded, label: 'إضافة مستأجر', color: AppColors.info),
      (icon: Icons.receipt_long_rounded, label: 'فاتورة جديدة', color: AppColors.success),
      (icon: Icons.build_circle_rounded, label: 'طلب صيانة', color: AppColors.warning),
    ];

    return Row(
      children: actions.map((a) {
        return Expanded(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              decoration: BoxDecoration(
                color: a.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: a.color.withValues(alpha: 0.25)),
              ),
              child: Column(
                children: [
                  Icon(a.icon, color: a.color, size: AppSpacing.iconLg),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    a.label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: a.color,
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ActivityFeed extends StatelessWidget {
  const _ActivityFeed();

  static const _items = [
    _ActivityItem(
      icon: Icons.home_rounded,
      title: 'تم تجديد عقد الوحدة 201',
      subtitle: 'منذ 15 دقيقة',
      accent: AppColors.success,
    ),
    _ActivityItem(
      icon: Icons.payment_rounded,
      title: 'استلام دفعة إيجار - 450 OMR',
      subtitle: 'منذ ساعة',
      accent: AppColors.gold,
    ),
    _ActivityItem(
      icon: Icons.build_rounded,
      title: 'طلب صيانة جديد - الوحدة 105',
      subtitle: 'منذ 3 ساعات',
      accent: AppColors.warning,
    ),
    _ActivityItem(
      icon: Icons.warning_rounded,
      title: 'إيجار متأخر - الوحدة 308',
      subtitle: 'منذ يوم',
      accent: AppColors.danger,
    ),
    _ActivityItem(
      icon: Icons.person_add_rounded,
      title: 'مستأجر جديد - أحمد العبدلي',
      subtitle: 'منذ يومين',
      accent: AppColors.info,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: AnimatedCard(
            accent: item.accent,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.base,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Container(
                  width: AppSpacing.avatarMd,
                  height: AppSpacing.avatarMd,
                  decoration: BoxDecoration(
                    color: item.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Icon(item.icon, color: item.accent, size: AppSpacing.iconSm),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      Text(
                        item.subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textMuted,
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.textMuted,
                  size: AppSpacing.iconMd,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ActivityItem {
  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
}
