import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/bootstrap_service.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({
    super.key,
    required this.items,
    required this.clients,
    required this.onPaid,
  });

  final List<Map<String, dynamic>> items;
  final List<Map<String, dynamic>> clients;
  final VoidCallback onPaid;

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  String _filter = 'all';

  String _clientName(String? id) =>
      '${widget.clients.firstWhere((c) => c['id'] == id, orElse: () => {'name': '—'})['name']}';

  List<Map<String, dynamic>> get _filtered {
    return widget.items.where((inv) {
      final status = '${inv['status'] ?? ''}';
      if (_filter == 'overdue') return status == 'Overdue';
      if (_filter == 'open') return status != 'Paid';
      return true;
    }).toList()
      ..sort((a, b) => '${b['due_date']}'.compareTo('${a['due_date']}'));
  }

  Future<void> _pay(Map<String, dynamic> invoice) async {
    final remaining = (invoice['amount'] as num? ?? 0) -
        (invoice['paid_amount'] as num? ?? 0);
    final bootstrap = context.read<BootstrapService>();
    final ctrl = TextEditingController(text: remaining.toStringAsFixed(3));
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تحصيل دفعة'),
        content: TextField(
          controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'المبلغ (${invoice['invoice_no']})',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('تسجيل')),
        ],
      ),
    );
    if (ok != true) return;
    final amount = double.tryParse(ctrl.text.trim()) ?? 0;
    if (amount <= 0) return;
    try {
      await bootstrap.payInvoice(
            invoiceId: '${invoice['id']}',
            amount: amount,
          );
      widget.onPaid();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تسجيل الدفعة')));
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
    final canPay = context.watch<AppState>().user?.can('invoices:write') ?? false;

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('الكل'),
                selected: _filter == 'all',
                onSelected: (_) => setState(() => _filter = 'all'),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('مفتوحة'),
                selected: _filter == 'open',
                onSelected: (_) => setState(() => _filter = 'open'),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('متأخرة'),
                selected: _filter == 'overdue',
                onSelected: (_) => setState(() => _filter = 'overdue'),
              ),
            ],
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? const EmptyState(message: 'لا توجد فواتير')
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final inv = items[i];
                    final remaining = (inv['amount'] as num? ?? 0) -
                        (inv['paid_amount'] as num? ?? 0);
                    return Card(
                      child: ListTile(
                        title: Text('${inv['invoice_no'] ?? inv['id']}'),
                        subtitle: Text(
                          '${_clientName(inv['client_id'])}\n'
                          'استحقاق: ${inv['due_date'] ?? ''}',
                        ),
                        isThreeLine: true,
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${inv['status'] ?? ''}'),
                            Text(money(remaining), style: const TextStyle(fontSize: 12)),
                            if (canPay && remaining > 0)
                              TextButton(onPressed: () => _pay(inv), child: const Text('تحصيل')),
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
