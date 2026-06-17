import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/bootstrap_service.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.data});

  final BootstrapData data;

  @override
  Widget build(BuildContext context) {
    final k = data.kpis;
    final decisions = data.decisions;

    return RefreshIndicator(
      onRefresh: () => context.read<AppState>().refresh(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'مرحباً ${data.user.name}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          Text(data.user.roleLabel, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.45,
            children: [
              KpiCard(label: 'الإيرادات', value: money(k['income'])),
              KpiCard(label: 'المصروفات', value: money(k['expense'])),
              KpiCard(label: 'الصافي', value: money(k['net']), color: AppTheme.goldDark),
              KpiCard(label: 'المتأخرات', value: money(k['overdue']), color: Colors.red.shade700),
              KpiCard(label: 'الإشغال', value: '${k['occupancy'] ?? 0}%'),
              KpiCard(label: 'صيانة مفتوحة', value: '${k['maintenance'] ?? 0}'),
              KpiCard(label: 'عقود تنتهي قريباً', value: '${k['expiring'] ?? 0}'),
              KpiCard(label: 'عقود منتهية', value: '${k['expired'] ?? 0}'),
            ],
          ),
          const SizedBox(height: 20),
          Text('قرارات تنفيذية', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (decisions.isEmpty)
            const EmptyState(message: 'لا توجد قرارات حالياً')
          else
            ...decisions.map(
              (d) => Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.gold.withValues(alpha: 0.15),
                    child: Text('${d['level'] ?? ''}'.substring(0, 1)),
                  ),
                  title: Text('${d['text'] ?? ''}'),
                  subtitle: Text('${d['level'] ?? ''}'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
