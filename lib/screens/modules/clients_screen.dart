import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key, required this.items});

  final List<Map<String, dynamic>> items;

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
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
    return widget.items.where((c) {
      final blob =
          '${c['name']} ${c['phone']} ${c['email']} ${c['national_id']}'.toLowerCase();
      return blob.contains(q);
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
            hint: 'بحث في العملاء',
            onChanged: (v) => setState(() => _query = v.trim()),
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? const EmptyState(message: 'لا يوجد عملاء')
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final c = items[i];
                    return Card(
                      child: ListTile(
                        title: Text('${c['name'] ?? '—'}'),
                        subtitle: Text(
                          '${c['phone'] ?? ''}\n${c['email'] ?? ''}',
                        ),
                        isThreeLine: true,
                        trailing: Text(
                          money(c['balance']),
                          style: TextStyle(
                            color: (c['balance'] ?? 0) > 0
                                ? Colors.red.shade700
                                : BrandColors.gold,
                            fontWeight: FontWeight.w600,
                          ),
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
