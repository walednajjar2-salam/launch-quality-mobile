import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/portal_data.dart';
import '../../state/portal_state.dart';
import '../../widgets/common.dart';
import '../../utils/format.dart';
import '../../utils/layout_breakpoints.dart';

class PortalShell extends StatefulWidget {
  const PortalShell({super.key});

  @override
  State<PortalShell> createState() => _PortalShellState();
}

class _PortalShellState extends State<PortalShell> {
  String? _selectedInvoiceId;
  final _proofAmount = TextEditingController();
  final _proofRef = TextEditingController();
  final _proofNote = TextEditingController();
  final _maintTitle = TextEditingController();

  @override
  void dispose() {
    _proofAmount.dispose();
    _proofRef.dispose();
    _proofNote.dispose();
    _maintTitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final portal = context.watch<PortalState>();
    final data = portal.data;
    if (data == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final tabs = ['نظرة عامة', 'الفواتير', 'المدفوعات', 'الصيانة'];
    final desktop = LayoutBreakpoints.isDesktop(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: AppCard(
                    accent: Theme.of(context).colorScheme.primary,
                    child: Row(
                      children: [
                        Image.asset('assets/logo.png', width: 42, height: 42),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.clientName,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'الرصيد: ${money(data.summary['balance'])}',
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'تحديث',
                          onPressed: portal.refresh,
                          icon: Icon(Icons.refresh, color: Theme.of(context).colorScheme.primary),
                        ),
                        IconButton(
                          tooltip: 'خروج',
                          onPressed: () async {
                            await portal.logout();
                            if (context.mounted) context.go('/portal');
                          },
                          icon: Icon(Icons.logout, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ),
                if (desktop)
                  NavigationBar(
                    selectedIndex: portal.tabIndex,
                    onDestinationSelected: portal.setTab,
                    destinations: tabs
                        .map((t) => NavigationDestination(icon: const Icon(Icons.circle), label: t))
                        .toList(),
                  )
                else
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: List.generate(tabs.length, (i) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: ChoiceChip(
                            label: Text(tabs[i]),
                            selected: portal.tabIndex == i,
                            onSelected: (_) {
                              HapticFeedback.selectionClick();
                              portal.setTab(i);
                            },
                          ),
                        );
                      }),
                    ),
                  ),
                Expanded(
                  child: IndexedStack(
                    index: portal.tabIndex,
                    children: [
                      _overview(data),
                      _invoices(context, portal, data),
                      _payments(data),
                      _maintenance(context, portal, data),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }

  Widget _overview(PortalData data) {
    final s = data.summary;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            KpiTile(label: 'إجمالي الفواتير', value: money(s['billed']), accent: Theme.of(context).colorScheme.primary),
            KpiTile(label: 'المدفوع', value: money(s['paid']), accent: Colors.green),
            KpiTile(label: 'الرصيد', value: money(s['balance']), accent: Theme.of(context).colorScheme.error),
            KpiTile(label: 'فواتير مفتوحة', value: '${s['open_invoices'] ?? 0}'),
          ],
        ),
        const SizedBox(height: 12),
        AppCard(
          child: Text('العقود النشطة: ${data.contracts.length}'),
        ),
      ],
    );
  }

  Widget _invoices(BuildContext context, PortalState portal, PortalData data) {
    final openInvoices = data.invoices.where((i) => '${i['status']}' != 'Paid').toList();
    _selectedInvoiceId ??= openInvoices.isNotEmpty ? '${openInvoices.first['id']}' : null;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...data.invoices.map((inv) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              accent: '${inv['status']}' == 'Paid' ? Colors.green : Theme.of(context).colorScheme.primary,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('${inv['invoice_no'] ?? inv['id']}'),
                subtitle: Text('الاستحقاق: ${inv['due_date'] ?? ''}'),
                trailing: Text(money(inv['amount']), style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        AppCard(
          accent: Theme.of(context).colorScheme.secondary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('رفع إثبات تحويل', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedInvoiceId,
                decoration: const InputDecoration(labelText: 'الفاتورة'),
                items: openInvoices
                    .map(
                      (i) => DropdownMenuItem(
                        value: '${i['id']}',
                        child: Text('${i['invoice_no'] ?? i['id']} — ${money(i['amount'])}'),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _selectedInvoiceId = v),
              ),
              const SizedBox(height: 10),
              TextField(controller: _proofAmount, decoration: const InputDecoration(labelText: 'المبلغ')),
              const SizedBox(height: 10),
              TextField(controller: _proofRef, decoration: const InputDecoration(labelText: 'مرجع التحويل')),
              const SizedBox(height: 10),
              TextField(controller: _proofNote, decoration: const InputDecoration(labelText: 'ملاحظة')),
              const SizedBox(height: 14),
              FilledButton(
                onPressed: () async {
                  final id = _selectedInvoiceId;
                  final amount = double.tryParse(_proofAmount.text.trim()) ?? 0;
                  if (id == null || amount <= 0) return;
                  try {
                    await portal.submitProof(
                      invoiceId: id,
                      amount: amount,
                      transferRef: _proofRef.text.trim(),
                      note: _proofNote.text.trim(),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم إرسال الإثبات')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
                    }
                  }
                },
                child: Text('إرسال الإثبات'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _payments(PortalData data) {
    if (data.payments.isEmpty) {
      return const EmptyState(message: 'لا توجد مدفوعات');
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: data.payments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final p = data.payments[i];
        return AppCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('${p['payment_date'] ?? ''}'),
            subtitle: Text('${p['method'] ?? ''}'),
            trailing: Text(money(p['amount']), style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }

  Widget _maintenance(BuildContext context, PortalState portal, PortalData data) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppCard(
          accent: Theme.of(context).colorScheme.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('طلب صيانة جديد', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              TextField(
                controller: _maintTitle,
                decoration: const InputDecoration(labelText: 'عنوان الطلب'),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () async {
                  final title = _maintTitle.text.trim();
                  if (title.isEmpty) return;
                  try {
                    await portal.submitMaintenance(title: title);
                    _maintTitle.clear();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم إرسال طلب الصيانة')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
                    }
                  }
                },
                child: const Text('إرسال'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...data.maintenance.map(
          (m) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('${m['title'] ?? ''}'),
                subtitle: Text('${m['status'] ?? ''} • ${m['request_date'] ?? ''}'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}