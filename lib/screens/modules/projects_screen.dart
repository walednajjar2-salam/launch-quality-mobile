import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/bootstrap_service.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/layout_breakpoints.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key, required this.data});

  final BootstrapData data;

  double _progress(Map<String, dynamic> property) {
    final status = '${property['status'] ?? ''}'.toLowerCase();
    final occupancy = _num(data.kpis['occupancy']);
    if (status.contains('rent') || status.contains('occupied')) {
      return occupancy.clamp(20, 100);
    }
    return (occupancy * 0.65).clamp(15, 85);
  }

  double _performance(Map<String, dynamic> property) {
    final health = _num(data.kpis['health']);
    final status = '${property['status'] ?? ''}'.toLowerCase();
    if (status.contains('rent')) return health.clamp(35, 100);
    return (health - 12).clamp(25, 95);
  }

  @override
  Widget build(BuildContext context) {
    final items = data.table('properties');
    final cols = LayoutBreakpoints.isDesktop(context) ? 2 : 1;

    return RefreshIndicator(
      color: BrandColors.gold,
      onRefresh: () => context.read<AppState>().refresh(),
      child: items.isEmpty
          ? ListView(
              children: const [
                SizedBox(height: 120),
                EmptyState(message: 'لا توجد مشاريع/عقارات'),
              ],
            )
          : GridView.builder(
              padding: EdgeInsets.all(LayoutBreakpoints.isDesktop(context) ? 24 : 16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: LayoutBreakpoints.isDesktop(context) ? 1.8 : 1.35,
              ),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final p = items[i];
                final progress = _progress(p);
                final perf = _performance(p);
                return GlassCard(
                  accent: BrandColors.gold,
                  child: Row(
                    children: [
                      CircularProgressRing(
                        progress: progress,
                        size: 84,
                        strokeWidth: 8,
                        accent: BrandColors.turquoise,
                        label: 'إنجاز',
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${p['name'] ?? 'مشروع'}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: BrandColors.goldBright,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'الحالة: ${p['status'] ?? 'نشط'}',
                              style: const TextStyle(color: BrandColors.textMuted),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'مؤشر الأداء ${perf.round()}%',
                              style: const TextStyle(
                                color: BrandColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  double _num(dynamic v) => (v is num) ? v.toDouble() : double.tryParse('$v') ?? 0;
}
