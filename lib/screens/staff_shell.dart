import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/bootstrap_service.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/layout_breakpoints.dart';
import 'modules/clients_screen.dart';
import 'modules/contracts_screen.dart';
import 'modules/dashboard_screen.dart';
import 'modules/finance_screen.dart';
import 'modules/invoices_screen.dart';
import 'modules/maintenance_screen.dart';
import 'modules/payment_proofs_screen.dart';
import 'modules/projects_screen.dart';
import 'modules/properties_screen.dart';
import 'modules/staff_screen.dart';

class StaffShell extends StatelessWidget {
  const StaffShell({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    if (app.status == AppStatus.error) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: LuxuryBackground(
            child: Center(
              child: GlassCard(
                accent: BrandColors.danger,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(app.errorMessage ?? 'تعذر تحميل البيانات'),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => app.refresh(),
                      child: const Text('إعادة المحاولة'),
                    ),
                    TextButton(
                      onPressed: () => app.logout(),
                      child: const Text('تسجيل الخروج'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    final bootstrap = app.bootstrap;
    if (bootstrap == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final tabs = _buildTabs(context, app, bootstrap);
    final index = app.navIndex.clamp(0, tabs.length - 1);
    final desktop = LayoutBreakpoints.isDesktop(context);
    final phoneTabs = _phoneNavTabs(tabs, index, app);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // On iPhone, keep bottom inset for the home indicator on NavigationBar only
        // (avoid double padding under the body).
        body: LuxuryBackground(
          child: SafeArea(
            bottom: desktop,
            child: Row(
              children: [
                if (desktop) _SideRail(tabs: tabs, index: index, onSelect: app.setNavIndex),
                Expanded(
                  child: Column(
                    children: [
                      _TopBar(
                        title: tabs[index].label,
                        userName: app.user?.name ?? '',
                        role: app.user?.roleLabel ?? '',
                        onRefresh: () => app.refresh(),
                        onLogout: () => app.logout(),
                        onPortal: () => context.go('/portal'),
                      ),
                      Expanded(
                        child: IndexedStack(
                          index: index,
                          children: tabs.map((t) => t.builder(context)).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: desktop
            ? null
            : NavigationBar(
                selectedIndex: phoneTabs.navIndex,
                onDestinationSelected: (i) {
                  HapticFeedback.selectionClick();
                  if (phoneTabs.moreIndex != null && i == phoneTabs.moreIndex) {
                    _showMoreModules(context, tabs, app);
                  } else {
                    app.setNavIndex(phoneTabs.mapToRealIndex(i));
                  }
                },
                destinations: phoneTabs.destinations,
              ),
      ),
    );
  }

  List<_StaffTab> _buildTabs(
    BuildContext context,
    AppState app,
    BootstrapData bootstrap,
  ) {
    return [
      _StaffTab('الرئيسية', Icons.dashboard_customize_outlined, (_) => DashboardScreen(data: bootstrap), true),
      _StaffTab('المشاريع', Icons.business_outlined, (_) => ProjectsScreen(data: bootstrap), true),
      _StaffTab('الموظفون', Icons.groups_2_outlined, (_) => StaffScreen(data: bootstrap), true),
      _StaffTab('المالية', Icons.insights_outlined, (_) => FinanceScreen(data: bootstrap), true),
      _StaffTab('الصيانة', Icons.build_circle_outlined, (_) => MaintenanceScreen(
            items: bootstrap.table('maintenance'),
            properties: bootstrap.table('properties'),
            onChanged: () => context.read<AppState>().refresh(),
          ), app.canRead('maintenance')),
      _StaffTab('إثباتات', Icons.verified_user_outlined, (_) => PaymentProofsScreen(
            bootstrap: context.read<BootstrapService>(),
            clients: bootstrap.table('clients'),
            invoices: bootstrap.table('invoices'),
            onChanged: () => context.read<AppState>().refresh(),
          ), app.canRead('invoices')),
      _StaffTab('العقارات', Icons.home_work_outlined, (_) => PropertiesScreen(items: bootstrap.table('properties')), app.canRead('properties')),
      _StaffTab('العملاء', Icons.people_outline, (_) => ClientsScreen(items: bootstrap.table('clients')), app.canRead('clients')),
      _StaffTab('العقود', Icons.description_outlined, (_) => ContractsScreen(
            items: bootstrap.table('contracts'),
            properties: bootstrap.table('properties'),
            clients: bootstrap.table('clients'),
          ), app.canRead('contracts')),
      _StaffTab('الفواتير', Icons.receipt_long_outlined, (_) => InvoicesScreen(
            items: bootstrap.table('invoices'),
            clients: bootstrap.table('clients'),
            onPaid: () => context.read<AppState>().refresh(),
          ), app.canRead('invoices')),
    ].where((t) => t.visible).toList();
  }

  _PhoneNav _phoneNavTabs(List<_StaffTab> tabs, int selected, AppState app) {
    const maxPrimary = 4;
    final primary = tabs.take(maxPrimary).toList();
    final hasMore = tabs.length > maxPrimary;
    final destinations = <NavigationDestination>[
      ...primary.map((t) => NavigationDestination(icon: Icon(t.icon), label: t.label)),
      if (hasMore) const NavigationDestination(icon: Icon(Icons.more_horiz), label: 'المزيد'),
    ];
    final moreIndex = hasMore ? destinations.length - 1 : null;
    var navIndex = selected;
    if (selected >= maxPrimary) {
      navIndex = moreIndex ?? selected.clamp(0, destinations.length - 1);
    } else {
      navIndex = selected.clamp(0, primary.length - 1);
    }
    return _PhoneNav(
      destinations: destinations,
      navIndex: navIndex,
      moreIndex: moreIndex,
      mapToRealIndex: (i) => i.clamp(0, tabs.length - 1),
    );
  }

  void _showMoreModules(BuildContext context, List<_StaffTab> tabs, AppState app) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: BrandColors.panel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(BrandColors.cornerRadius)),
      ),
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (var i = 4; i < tabs.length; i++)
              ListTile(
                leading: Icon(tabs[i].icon, color: BrandColors.goldBright),
                title: Text(tabs[i].label),
                onTap: () {
                  app.setNavIndex(i);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _PhoneNav {
  _PhoneNav({
    required this.destinations,
    required this.navIndex,
    required this.moreIndex,
    required this.mapToRealIndex,
  });

  final List<NavigationDestination> destinations;
  final int navIndex;
  final int? moreIndex;
  final int Function(int) mapToRealIndex;
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    required this.userName,
    required this.role,
    required this.onRefresh,
    required this.onLogout,
    required this.onPortal,
  });

  final String title;
  final String userName;
  final String role;
  final VoidCallback onRefresh;
  final VoidCallback onLogout;
  final VoidCallback onPortal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: GlassCard(
        accent: BrandColors.gold,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Image.asset('assets/logo.png', width: 36, height: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: BrandColors.goldBright, fontWeight: FontWeight.bold)),
                  Text('$userName · $role', style: const TextStyle(color: BrandColors.textMuted, fontSize: 12)),
                ],
              ),
            ),
            IconButton(tooltip: 'تحديث', onPressed: onRefresh, icon: const Icon(Icons.refresh, color: BrandColors.goldBright)),
            IconButton(tooltip: 'بوابة المستأجر', onPressed: onPortal, icon: const Icon(Icons.link, color: BrandColors.turquoise)),
            IconButton(tooltip: 'خروج', onPressed: onLogout, icon: const Icon(Icons.logout, color: BrandColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

class _SideRail extends StatelessWidget {
  const _SideRail({required this.tabs, required this.index, required this.onSelect});

  final List<_StaffTab> tabs;
  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: index,
      onDestinationSelected: onSelect,
      labelType: NavigationRailLabelType.all,
      backgroundColor: BrandColors.panel.withValues(alpha: 0.92),
      destinations: tabs
          .map((t) => NavigationRailDestination(icon: Icon(t.icon), label: Text(t.label)))
          .toList(),
    );
  }
}

class _StaffTab {
  _StaffTab(this.label, this.icon, this.builder, this.visible);

  final String label;
  final IconData icon;
  final WidgetBuilder builder;
  final bool visible;
}
