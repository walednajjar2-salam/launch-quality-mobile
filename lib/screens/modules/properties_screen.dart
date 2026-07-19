import 'package:flutter/material.dart';

import '../../widgets/common.dart';
import '../../utils/format.dart';

class PropertiesScreen extends StatefulWidget {
  const PropertiesScreen({super.key, required this.items});

  final List<Map<String, dynamic>> items;

  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered {
    if (_query.isEmpty) return widget.items;
    final q = _query.toLowerCase();
    return widget.items.where((p) {
      final name = '${p['name'] ?? ''}'.toLowerCase();
      final loc = '${p['location'] ?? ''}'.toLowerCase();
      final status = '${p['status'] ?? ''}'.toLowerCase();
      return name.contains(q) || loc.contains(q) || status.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: SearchField(
            controller: _search,
            hint: 'بحث في العقارات',
            onChanged: (v) => setState(() => _query = v.trim()),
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? const EmptyState(message: 'لا توجد عقارات')
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final p = items[i];
                    return Card(
                      child: ListTile(
                        title: Text('${p['name'] ?? '—'}'),
                        subtitle: Text('${p['location'] ?? ''}\n${p['type'] ?? ''}'),
                        isThreeLine: true,
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${p['status'] ?? ''}'),
                            Text(money(p['price']), style: const TextStyle(fontSize: 12)),
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
