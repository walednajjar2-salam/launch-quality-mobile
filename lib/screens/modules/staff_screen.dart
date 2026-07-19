import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/bootstrap_service.dart';
import '../../state/app_state.dart';
import '../../widgets/common.dart';
import '../../utils/layout_breakpoints.dart';

class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key, required this.data});

  final BootstrapData data;

  @override
  Widget build(BuildContext context) {
    final employees = data.table('employees');
    final active = employees.where((e) {
      final status = '${e['status'] ?? 'active'}'.toLowerCase();
      return status.contains('active') || status.contains('نشط');
    }).length;
    final absences = (employees.length - active).clamp(0, employees.length);
    final cols = LayoutBreakpoints.gridColumns(context);

    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
      onRefresh: () => context.read<AppState>().refresh(),
      child: ListView(
        padding: EdgeInsets.all(LayoutBreakpoints.isDesktop(context) ? 24 : 16),
        children: [
          GridView.count(
            crossAxisCount: cols.clamp(2, 4),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.45,
            children: [
              KpiTile(
                label: 'الحضور',
                value: '$active',
                icon: Icons.person_pin_circle_outlined,
                accent: Colors.green,
              ),
              KpiTile(
                label: 'الغياب',
                value: '$absences',
                icon: Icons.person_off_outlined,
                accent: Theme.of(context).colorScheme.error,
              ),
              KpiTile(
                label: 'المناوبات',
                value: '${active.clamp(0, 12)}',
                icon: Icons.schedule_outlined,
                accent: Theme.of(context).colorScheme.primary,
              ),
              KpiTile(
                label: 'نشطون',
                value: '$active',
                icon: Icons.groups_2_outlined,
                accent: Theme.of(context).colorScheme.secondary,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'قائمة الموظفين',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          if (employees.isEmpty)
            const EmptyState(message: 'لا توجد بيانات موظفين')
          else
            ...employees.map((e) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  accent: Theme.of(context).colorScheme.tertiary,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                      child: Text(
                        '${e['name'] ?? '?'}'.substring(0, 1),
                        style: TextStyle(color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    title: Text('${e['name'] ?? ''}'),
                    subtitle: Text('${e['status'] ?? ''} • ${e['role'] ?? ''}'),
                    trailing: Icon(
                      '${e['status'] ?? ''}'.toLowerCase().contains('active')
                          ? Icons.check_circle
                          : Icons.remove_circle_outline,
                      color: '${e['status'] ?? ''}'.toLowerCase().contains('active')
                          ? Colors.green
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
