import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/bootstrap_service.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/layout_breakpoints.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.data});

  final BootstrapData data;

  @override
  Widget build(BuildContext context) {
    final k = data.kpis;
    final decisions = data.decisions;
    final health = _num(k['health']);
    final cols = LayoutBreakpoints.gridColumns(context);

    return RefreshIndicator(
      color: BrandColors.gold,
      onRefresh: () => context.read<AppState>().refresh(),
      child: ListView(
        padding: EdgeInsets.all(LayoutBreakpoints.isDesktop(context) ? 24 : 16),
        children: [
          GlassCard(
            accent: BrandColors.turquoise,
            child: Row(
              children: [
                CircularProgressRing(
                  progress: health,
                  size: 110,
                  strokeWidth: 10,
                  accent: BrandColors.gold,
                  label: 'إنجاز',
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مرحباً ${data.user.name}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: BrandColors.goldBright,
                            ),
                      ),
                      Text(data.user.roleLabel, style: const TextStyle(color: BrandColors.textMuted)),
                      const SizedBox(height: 10),
                      Text('المشاريع النشطة: ${k['rented'] ?? k['properties'] ?? 0}'),
                      Text('الإيرادات: ${money(k['income'])}'),
                      Text('التنبيهات: ${k['overdue'] ?? 0}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: cols.clamp(2, 4),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.45,
            children: [
              KpiTile(label: 'الإيرادات', value: money(k['income']), icon: Icons.trending_up),
              KpiTile(label: 'المصروفات', value: money(k['expense']), icon: Icons.trending_down, accent: BrandColors.danger),
              KpiTile(label: 'الصافي', value: money(k['net']), accent: BrandColors.gold),
              KpiTile(label: 'المتأخرات', value: money(k['overdue']), accent: BrandColors.danger, valueColor: BrandColors.danger),
              KpiTile(label: 'الإشغال', value: '${k['occupancy'] ?? 0}%', accent: BrandColors.turquoise),
              KpiTile(label: 'صيانة مفتوحة', value: '${k['maintenance'] ?? 0}'),
              KpiTile(label: 'عقود تنتهي', value: '${k['expiring'] ?? 0}'),
              KpiTile(label: 'عقود منتهية', value: '${k['expired'] ?? 0}'),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'آخر النشاطات / قرارات تنفيذية',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: BrandColors.goldBright,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          if (decisions.isEmpty)
            const EmptyState(message: 'لا توجد قرارات حالياً')
          else
            ...decisions.map(
              (d) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GlassCard(
                  accent: '${d['level']}' == 'High' ? BrandColors.danger : BrandColors.gold,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: BrandColors.gold.withValues(alpha: 0.15),
                      child: Text('${d['level'] ?? ''}'.isNotEmpty ? '${d['level']}'.substring(0, 1) : '?'),
                    ),
                    title: Text('${d['text'] ?? ''}'),
                    subtitle: Text('${d['level'] ?? ''}'),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  double _num(dynamic v) => (v is num) ? v.toDouble() : double.tryParse('$v') ?? 0;
}
