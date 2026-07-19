import 'dart:convert';

import 'package:flutter/material.dart';

import '../../config/api_config.dart';
import '../../services/bootstrap_service.dart';
import '../../widgets/common.dart';
import '../../utils/format.dart';

class PaymentProofsScreen extends StatefulWidget {
  const PaymentProofsScreen({
    super.key,
    required this.bootstrap,
    required this.clients,
    required this.invoices,
    required this.onChanged,
  });

  final BootstrapService bootstrap;
  final List<Map<String, dynamic>> clients;
  final List<Map<String, dynamic>> invoices;
  final VoidCallback onChanged;

  @override
  State<PaymentProofsScreen> createState() => _PaymentProofsScreenState();
}

class _PaymentProofsScreenState extends State<PaymentProofsScreen> {
  static const _filterIds = ['pending', 'approved', 'rejected', 'all'];
  static const _filterLabels = {
    'pending': 'معلّقة',
    'approved': 'موافق عليها',
    'rejected': 'مرفوضة',
    'all': 'الكل',
  };

  String _status = 'pending';
  late Future<_ProofsPayload> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_ProofsPayload> _load() async {
    if (_status == 'all') {
      final results = await Future.wait([
        widget.bootstrap.portalProofs(status: 'pending'),
        widget.bootstrap.portalProofs(status: 'approved'),
        widget.bootstrap.portalProofs(status: 'rejected'),
      ]);
      final counts = {
        'pending': results[0].length,
        'approved': results[1].length,
        'rejected': results[2].length,
      };
      final items = [...results[0], ...results[1], ...results[2]]
        ..sort((a, b) => '${b['submitted_at'] ?? ''}'.compareTo('${a['submitted_at'] ?? ''}'));
      return _ProofsPayload(items: items, counts: counts);
    }

    final items = await widget.bootstrap.portalProofs(status: _status);
    final counts = await _loadCounts();
    return _ProofsPayload(items: items, counts: counts);
  }

  Future<Map<String, int>> _loadCounts() async {
    final results = await Future.wait([
      widget.bootstrap.portalProofs(status: 'pending'),
      widget.bootstrap.portalProofs(status: 'approved'),
      widget.bootstrap.portalProofs(status: 'rejected'),
    ]);
    return {
      'pending': results[0].length,
      'approved': results[1].length,
      'rejected': results[2].length,
    };
  }

  Future<void> _reload() async {
    setState(() {
      _future = _load();
    });
    widget.onChanged();
  }

  String _clientName(String? clientId) {
    if (clientId == null || clientId.isEmpty) return '—';
    for (final c in widget.clients) {
      if ('${c['id']}' == clientId) return '${c['name'] ?? '—'}';
    }
    return '—';
  }

  Map<String, dynamic> _invoice(String? invoiceId) {
    if (invoiceId == null || invoiceId.isEmpty) return const {};
    for (final i in widget.invoices) {
      if ('${i['id']}' == invoiceId) return i;
    }
    return const {};
  }

  String _invoiceLabel(String? invoiceId) {
    final inv = _invoice(invoiceId);
    if (inv.isEmpty) return invoiceId ?? '—';
    return '${inv['invoice_no'] ?? inv['id']}';
  }

  String _statusLabel(String? status) {
    switch ('${status ?? ''}'.toLowerCase()) {
      case 'approved':
        return 'موافق';
      case 'rejected':
        return 'مرفوض';
      default:
        return 'معلّق';
    }
  }

  Color _statusColor(String? status) {
    switch ('${status ?? ''}'.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Theme.of(context).colorScheme.error;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  bool _isPending(Map<String, dynamic> proof) {
    final status = '${proof['status'] ?? 'pending'}'.toLowerCase();
    return status.isEmpty || status == 'pending';
  }

  Future<String?> _askReviewNote(String action) async {
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(action == 'approve' ? 'تأكيد الموافقة' : 'تأكيد الرفض'),
        content: TextField(
          controller: ctrl,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'ملاحظة المراجعة (اختياري)',
            alignLabelWithHint: true,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('تأكيد')),
        ],
      ),
    );
    if (ok != true) return null;
    final note = ctrl.text.trim();
    return note.isEmpty ? '' : note;
  }

  Future<void> _review(Map<String, dynamic> proof, String action) async {
    final note = await _askReviewNote(action);
    if (note == null) return;
    try {
      await widget.bootstrap.reviewProof(
        proofId: '${proof['id']}',
        action: action,
        reviewNote: note.isEmpty ? null : note,
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

  void _previewImage(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا توجد صورة مرفقة')),
      );
      return;
    }
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520, maxHeight: 640),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                title: const Text('إثبات التحويل'),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
                ],
              ),
              Expanded(child: _ProofImage(raw: raw.trim())),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_ProofsPayload>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return EmptyState(message: '${snap.error}');
        }
        final payload = snap.data ?? _ProofsPayload.empty();
        final items = payload.items;
        final counts = payload.counts;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: LayoutBuilder(
                builder: (context, c) {
                  final wide = c.maxWidth > 720;
                  final tiles = [
                    KpiTile(
                      label: 'معلّقة',
                      value: '${counts['pending'] ?? 0}',
                      icon: Icons.hourglass_top_outlined,
                      accent: Theme.of(context).colorScheme.primary,
                    ),
                    KpiTile(
                      label: 'موافق',
                      value: '${counts['approved'] ?? 0}',
                      icon: Icons.verified_outlined,
                      accent: Colors.green,
                    ),
                    KpiTile(
                      label: 'مرفوض',
                      value: '${counts['rejected'] ?? 0}',
                      icon: Icons.block_outlined,
                      accent: Theme.of(context).colorScheme.error,
                    ),
                  ];
                  if (wide) {
                    return Row(
                      children: [
                        for (var i = 0; i < tiles.length; i++) ...[
                          if (i > 0) const SizedBox(width: 10),
                          Expanded(child: tiles[i]),
                        ],
                      ],
                    );
                  }
                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: tiles.map((t) => SizedBox(width: (c.maxWidth - 10) / 2, child: t)).toList(),
                  );
                },
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: _filterIds.map((id) {
                  final selected = _status == id;
                  return Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: ChoiceChip(
                      label: Text(_filterLabels[id] ?? id),
                      selected: selected,
                      onSelected: (_) {
                        setState(() {
                          _status = id;
                          _future = _load();
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? const EmptyState(
                      message: 'لا توجد إثباتات في هذا التصنيف',
                      icon: Icons.verified_outlined,
                    )
                  : RefreshIndicator(
                      onRefresh: _reload,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) => _ProofCard(
                          proof: items[i],
                          invoiceLabel: _invoiceLabel('${items[i]['invoice_id']}'),
                          clientName: _clientName(_invoice('${items[i]['invoice_id']}')['client_id']?.toString()),
                          statusLabel: _statusLabel(items[i]['status']?.toString()),
                          statusColor: _statusColor(items[i]['status']?.toString()),
                          pending: _isPending(items[i]),
                          onPreview: () => _previewImage(items[i]['proof_image']?.toString()),
                          onApprove: () => _review(items[i], 'approve'),
                          onReject: () => _review(items[i], 'reject'),
                        ),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _ProofsPayload {
  const _ProofsPayload({required this.items, required this.counts});

  factory _ProofsPayload.empty() => const _ProofsPayload(items: [], counts: {});

  final List<Map<String, dynamic>> items;
  final Map<String, int> counts;
}

class _ProofCard extends StatelessWidget {
  const _ProofCard({
    required this.proof,
    required this.invoiceLabel,
    required this.clientName,
    required this.statusLabel,
    required this.statusColor,
    required this.pending,
    required this.onPreview,
    required this.onApprove,
    required this.onReject,
  });

  final Map<String, dynamic> proof;
  final String invoiceLabel;
  final String clientName;
  final String statusLabel;
  final Color statusColor;
  final bool pending;
  final VoidCallback onPreview;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final reviewNote = '${proof['review_note'] ?? ''}'.trim();
    return AppCard(
      accent: statusColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${proof['transfer_ref'] ?? proof['id']}',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Text('فاتورة: $invoiceLabel'),
                    Text('العميل: $clientName'),
                    Text('تاريخ الإرسال: ${proof['submitted_at'] ?? '—'}'),
                    if ('${proof['note'] ?? ''}'.trim().isNotEmpty)
                      Text('ملاحظة المستأجر: ${proof['note']}'),
                    if (reviewNote.isNotEmpty) Text('ملاحظة المراجعة: $reviewNote'),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: statusColor.withValues(alpha: 0.35)),
                    ),
                    child: Text(statusLabel, style: TextStyle(color: statusColor, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 8),
                  Text(money(proof['amount']), style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: onPreview,
                icon: const Icon(Icons.image_outlined, size: 18),
                label: const Text('معاينة'),
              ),
              const Spacer(),
              if (pending) ...[
                IconButton(
                  tooltip: 'موافقة',
                  onPressed: onApprove,
                  icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                ),
                IconButton(
                  tooltip: 'رفض',
                  onPressed: onReject,
                  icon: Icon(Icons.cancel_outlined, color: Colors.red.shade700),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ProofImage extends StatelessWidget {
  const _ProofImage({required this.raw});

  final String raw;

  @override
  Widget build(BuildContext context) {
    if (raw.startsWith('data:image')) {
      try {
        final encoded = raw.split(',').last;
        final bytes = base64Decode(encoded);
        return InteractiveViewer(child: Image.memory(bytes, fit: BoxFit.contain));
      } catch (_) {
        return const Center(child: Text('تعذر عرض الصورة'));
      }
    }
    final base = Uri.parse(ApiConfig.baseUrl);
    final origin = '${base.scheme}://${base.host}${base.hasPort ? ':${base.port}' : ''}';
    final uri = raw.startsWith('http') ? raw : '$origin$raw';
    return InteractiveViewer(
      child: Image.network(
        uri,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Center(child: Text('تعذر تحميل الصورة')),
      ),
    );
  }
}
