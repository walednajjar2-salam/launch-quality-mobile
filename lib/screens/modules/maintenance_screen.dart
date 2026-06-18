import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/bootstrap_service.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({
    super.key,
    required this.items,
    required this.properties,
    required this.onChanged,
  });

  final List<Map<String, dynamic>> items;
  final List<Map<String, dynamic>> properties;
  final VoidCallback onChanged;

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  String _filter = 'open';

  String _propertyName(String? id) =>
      '${widget.properties.firstWhere((p) => p['id'] == id, orElse: () => {'name': '—'})['name']}';

  List<Map<String, dynamic>> get _filtered {
    return widget.items.where((m) {
      final status = '${m['status'] ?? ''}'.toLowerCase();
      if (_filter == 'open') return status != 'closed' && status != 'done';
      if (_filter == 'tenant') return '${m['source']}' == 'tenant';
      return true;
    }).toList();
  }

  Future<void> _setStatus(Map<String, dynamic> item, String status) async {
    try {
      final updated = Map<String, dynamic>.from(item)..['status'] = status;
      await context.read<BootstrapService>().updateMaintenance(updated);
      widget.onChanged();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تحديث الطلب')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;
    final canWrite = context.watch<AppState>().user?.can('maintenance:write') ?? false;

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('مفتوحة'),
                selected: _filter == 'open',
                onSelected: (_) => setState(() => _filter = 'open'),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('من المستأجر'),
                selected: _filter == 'tenant',
                onSelected: (_) => setState(() => _filter = 'tenant'),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('الكل'),
                selected: _filter == 'all',
                onSelected: (_) => setState(() => _filter = 'all'),
              ),
            ],
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? const EmptyState(message: 'لا توجد طلبات صيانة')
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final m = items[i];
                    return GlassCard(
                      accent: BrandColors.tealDeep,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text('${m['title'] ?? 'طلب صيانة'}'),
                        subtitle: Text(
                          '${_propertyName(m['property_id'])}\n'
                          'الأولوية: ${m['priority'] ?? ''} • المصدر: ${m['source'] ?? 'staff'}',
                        ),
                        isThreeLine: true,
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${m['status'] ?? ''}'),
                            if (canWrite)
                              PopupMenuButton<String>(
                                onSelected: (v) => _setStatus(m, v),
                                itemBuilder: (_) => const [
                                  PopupMenuItem(value: 'In Progress', child: Text('قيد التنفيذ')),
                                  PopupMenuItem(value: 'Closed', child: Text('مغلق')),
                                ],
                                icon: const Icon(Icons.more_vert),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
