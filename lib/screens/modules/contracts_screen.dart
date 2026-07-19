import 'package:flutter/material.dart';

import '../../widgets/common.dart';
import '../../utils/format.dart';

class ContractsScreen extends StatefulWidget {
  const ContractsScreen({
    super.key,
    required this.items,
    required this.properties,
    required this.clients,
  });

  final List<Map<String, dynamic>> items;
  final List<Map<String, dynamic>> properties;
  final List<Map<String, dynamic>> clients;

  @override
  State<ContractsScreen> createState() => _ContractsScreenState();
}

class _ContractsScreenState extends State<ContractsScreen> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  String _clientName(String? id) =>
      '${widget.clients.firstWhere((x) => x['id'] == id, orElse: () => {'name': '—'})['name']}';

  String _propertyName(String? id) =>
      '${widget.properties.firstWhere((x) => x['id'] == id, orElse: () => {'name': '—'})['name']}';

  List<Map<String, dynamic>> get _filtered {
    if (_query.isEmpty) return widget.items;
    final q = _query.toLowerCase();
    return widget.items.where((c) {
      final blob =
          '${c['contract_no']} ${c['status']} ${_clientName(c['client_id'])} ${_propertyName(c['property_id'])}'
              .toLowerCase();
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
            hint: 'بحث في العقود',
            onChanged: (v) => setState(() => _query = v.trim()),
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? const EmptyState(message: 'لا توجد عقود')
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final c = items[i];
                    return Card(
                      child: ListTile(
                        title: Text('${c['contract_no'] ?? c['id'] ?? '—'}'),
                        subtitle: Text(
                          'العميل: ${_clientName(c['client_id'])}\n'
                          'العقار: ${_propertyName(c['property_id'])}\n'
                          '${c['start_date'] ?? ''} → ${c['end_date'] ?? ''}',
                        ),
                        isThreeLine: true,
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${c['status'] ?? ''}'),
                            Text(money(c['rent_amount']), style: const TextStyle(fontSize: 12)),
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
