import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/bootstrap_service.dart';
import '../state/app_state.dart';
import 'modules/clients_screen.dart';
import 'modules/contracts_screen.dart';
import 'modules/dashboard_screen.dart';
import 'modules/invoices_screen.dart';
import 'modules/maintenance_screen.dart';
import 'modules/payment_proofs_screen.dart';
import 'modules/properties_screen.dart';

class StaffShell extends StatelessWidget {
  const StaffShell({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final bootstrap = app.bootstrap;
    if (bootstrap == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final destinations = <_StaffTab>[
      _StaffTab(
        label: 'الرئيسية',
        icon: Icons.dashboard_outlined,
        builder: (_) => DashboardScreen(data: bootstrap),
        visible: true,
      ),
      _StaffTab(
        label: 'العقارات',
        icon: Icons.home_work_outlined,
        builder: (_) => PropertiesScreen(items: bootstrap.table('properties')),
        visible: app.canRead('properties'),
      ),
      _StaffTab(
        label: 'العملاء',
        icon: Icons.people_outline,
        builder: (_) => ClientsScreen(items: bootstrap.table('clients')),
        visible: app.canRead('clients'),
      ),
      _StaffTab(
        label: 'العقود',
        icon: Icons.description_outlined,
        builder: (_) => ContractsScreen(
          items: bootstrap.table('contracts'),
          properties: bootstrap.table('properties'),
          clients: bootstrap.table('clients'),
        ),
        visible: app.canRead('contracts'),
      ),
      _StaffTab(
        label: 'الفواتير',
        icon: Icons.receipt_long_outlined,
        builder: (_) => InvoicesScreen(
          items: bootstrap.table('invoices'),
          clients: bootstrap.table('clients'),
          onPaid: () => context.read<AppState>().refresh(),
        ),
        visible: app.canRead('invoices'),
      ),
      _StaffTab(
        label: 'الصيانة',
        icon: Icons.build_outlined,
        builder: (_) => MaintenanceScreen(
          items: bootstrap.table('maintenance'),
          properties: bootstrap.table('properties'),
          onChanged: () => context.read<AppState>().refresh(),
        ),
        visible: app.canRead('maintenance'),
      ),
      _StaffTab(
        label: 'إثباتات',
        icon: Icons.verified_outlined,
        builder: (_) => PaymentProofsScreen(
          bootstrap: context.read<BootstrapService>(),
          onChanged: () => context.read<AppState>().refresh(),
        ),
        visible: app.canRead('invoices'),
      ),
    ].where((t) => t.visible).toList();

    final index = app.navIndex.clamp(0, destinations.length - 1);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(destinations[index].label),
          actions: [
            IconButton(
              tooltip: 'تحديث',
              onPressed: () => context.read<AppState>().refresh(),
              icon: const Icon(Icons.refresh),
            ),
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'logout') context.read<AppState>().logout();
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  enabled: false,
                  child: Text('${app.user?.name}\n${app.user?.roleLabel}'),
                ),
                const PopupMenuItem(value: 'logout', child: Text('تسجيل الخروج')),
              ],
            ),
          ],
        ),
        body: IndexedStack(
          index: index,
          children: destinations.map((d) => d.builder(context)).toList(),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: app.setNavIndex,
          destinations: destinations
              .map(
                (d) => NavigationDestination(
                  icon: Icon(d.icon),
                  label: d.label,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _StaffTab {
  _StaffTab({
    required this.label,
    required this.icon,
    required this.builder,
    required this.visible,
  });

  final String label;
  final IconData icon;
  final WidgetBuilder builder;
  final bool visible;
}
