import 'package:flutter/material.dart';
import '../../services/bootstrap_service.dart';
import '../../theme/app_theme.dart';

class PaymentProofsScreen extends StatefulWidget {
  const PaymentProofsScreen({
    super.key,
    required this.bootstrap,
    required this.onChanged,
  });

  final BootstrapService bootstrap;
  final VoidCallback onChanged;

  @override
  State<PaymentProofsScreen> createState() => _PaymentProofsScreenState();
}

class _PaymentProofsScreenState extends State<PaymentProofsScreen> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.bootstrap.portalProofs(status: 'pending');
  }

  Future<void> _reload() async {
    setState(() {
      _future = widget.bootstrap.portalProofs(status: 'pending');
    });
    widget.onChanged();
  }

  Future<void> _review(Map<String, dynamic> proof, String action) async {
    try {
      await widget.bootstrap.reviewProof(
        proofId: '${proof['id']}',
        action: action,
      );
      await _reload();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(action == 'approve' ? 'تمت الموافقة' : 'تم الرفض')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return EmptyState(message: '${snap.error}');
        }
        final items = snap.data ?? [];
        if (items.isEmpty) {
          return const EmptyState(
            message: 'لا توجد إثباتات دفع معلّقة',
            icon: Icons.verified_outlined,
          );
        }
        return RefreshIndicator(
          onRefresh: _reload,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final p = items[i];
              return Card(
                child: ListTile(
                  title: Text('${p['transfer_ref'] ?? p['id']}'),
                  subtitle: Text(
                    'فاتورة: ${p['invoice_id'] ?? ''}\n'
                    'تاريخ: ${p['submitted_at'] ?? ''}',
                  ),
                  isThreeLine: true,
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(money(p['amount']), style: const TextStyle(fontWeight: FontWeight.w700)),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'موافقة',
                            onPressed: () => _review(p, 'approve'),
                            icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                          ),
                          IconButton(
                            tooltip: 'رفض',
                            onPressed: () => _review(p, 'reject'),
                            icon: Icon(Icons.cancel_outlined, color: Colors.red.shade700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
