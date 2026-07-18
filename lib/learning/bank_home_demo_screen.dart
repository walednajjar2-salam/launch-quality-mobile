import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'bank_home_demo_data.dart';

/// شاشة رئيسية بنكية تجريبية — لأغراض التعلّم فقط.
/// ليست تطبيقاً بنكياً حقيقياً ولا تتصل بأي بنك.
class BankHomeDemoScreen extends StatefulWidget {
  const BankHomeDemoScreen({super.key});

  @override
  State<BankHomeDemoScreen> createState() => _BankHomeDemoScreenState();
}

class _BankHomeDemoScreenState extends State<BankHomeDemoScreen> {
  bool _balanceVisible = true;
  int _navIndex = 0;
  late double _balance;
  late final TextEditingController _balanceController;

  static final _amountFmt = NumberFormat('#,##0.000', 'en_US');

  @override
  void initState() {
    super.initState();
    _balance = BankHomeDemoData.balance;
    _balanceController = TextEditingController(text: _balance.toStringAsFixed(3));
  }

  @override
  void dispose() {
    _balanceController.dispose();
    super.dispose();
  }

  String get _formattedBalance {
    if (!_balanceVisible) return '••••••';
    return '${_amountFmt.format(_balance)} ${BankHomeDemoData.currency}';
  }

  void _applyBalanceEdit() {
    final parsed = double.tryParse(_balanceController.text.trim());
    if (parsed == null || parsed < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أدخل رقماً صحيحاً للرصيد')),
      );
      return;
    }
    setState(() {
      _balance = double.parse(parsed.toStringAsFixed(3));
      _balanceVisible = true;
      _balanceController.text = _balance.toStringAsFixed(3);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B1F3A),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildBalanceCard(),
                    const SizedBox(height: 12),
                    _buildBalanceEditor(),
                    const SizedBox(height: 16),
                    _buildQuickActions(),
                    const SizedBox(height: 16),
                    _buildPromoBanner(),
                    const SizedBox(height: 20),
                    _buildTransactionsHeader(),
                    const SizedBox(height: 10),
                    ...BankHomeDemoData.transactions.map(_buildTransactionTile),
                    const SizedBox(height: 12),
                    const Text(
                      'تجريبي للتعلّم — عدّل الرصيد من الخانة أعلاه',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0x88FFFFFF),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              _buildBottomNav(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            BankHomeDemoData.userName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0x22FFFFFF),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(Icons.person_outline, color: Colors.white, size: 20),
        ),
      ],
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A3355), Color(0xFF12263F)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x33FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            BankHomeDemoData.balanceTitle,
            style: const TextStyle(
              color: Color(0xCCFFFFFF),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  _formattedBalance,
                  style: const TextStyle(
                    color: Color(0xFFFF8A3D),
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _balanceVisible = !_balanceVisible),
                icon: Icon(
                  _balanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.description_outlined, color: Colors.white54, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  BankHomeDemoData.accountLabel,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ),
              Text(
                BankHomeDemoData.viewDetailsLabel,
                style: const TextStyle(
                  color: Color(0xFFFF8A3D),
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                  decorationColor: Color(0xFFFF8A3D),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceEditor() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0x22FF8A3D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x88FF8A3D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'تعديل الرصيد (للتعلّم)',
            style: TextStyle(
              color: Color(0xFFFF8A3D),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _balanceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'الرصيد الجديد',
              labelStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: const Color(0x33000000),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0x44FFFFFF)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0x44FFFFFF)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFFF8A3D)),
              ),
            ),
            onSubmitted: (_) => _applyBalanceEdit(),
          ),
          const SizedBox(height: 10),
          FilledButton(
            onPressed: _applyBalanceEdit,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFF8A3D),
              foregroundColor: const Color(0xFF12263F),
              minimumSize: const Size.fromHeight(42),
            ),
            child: const Text(
              'تطبيق الرصيد',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(child: _actionButton(BankHomeDemoData.moneyAction, Icons.account_balance_wallet_outlined)),
        const SizedBox(width: 12),
        Expanded(child: _actionButton(BankHomeDemoData.goalsAction, Icons.flag_outlined)),
      ],
    );
  }

  Widget _actionButton(String label, IconData icon) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF6B4E2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                colors: [Color(0xFF1A3355), Color(0xFFFF8A3D)],
              ),
            ),
            child: const Icon(Icons.credit_card, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  BankHomeDemoData.promoTitle,
                  style: const TextStyle(
                    color: Color(0xFF12263F),
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  BankHomeDemoData.promoSubtitle,
                  style: const TextStyle(
                    color: Color(0xFF5A6B7D),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            BankHomeDemoData.transactionsTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          BankHomeDemoData.viewAllLabel,
          style: const TextStyle(
            color: Color(0xFFFF8A3D),
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionTile(DemoTransaction tx) {
    final sign = tx.isCredit ? '+' : '-';
    final color = tx.isCredit ? const Color(0xFF34D399) : const Color(0xFFF87171);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0x14FFFFFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0x22FFFFFF),
            child: Icon(
              tx.isCredit ? Icons.south_west : Icons.north_east,
              color: color,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                Text(
                  '${tx.subtitle} · ${tx.date}',
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            '$sign${_amountFmt.format(tx.amount)} ${BankHomeDemoData.currency}',
            style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    const items = [
      (Icons.home_outlined, 'الرئيسية'),
      (Icons.credit_card_outlined, 'البطاقات'),
      (Icons.swap_horiz, 'التحويلات'),
      (Icons.payments_outlined, 'المدفوعات'),
      (Icons.more_horiz, 'المزيد'),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF0A1A30),
        border: Border(top: BorderSide(color: Color(0x22FFFFFF))),
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _navIndex = i),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      items[i].$1,
                      color: _navIndex == i ? const Color(0xFFFF8A3D) : Colors.white54,
                      size: 22,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      items[i].$2,
                      style: TextStyle(
                        color: _navIndex == i ? const Color(0xFFFF8A3D) : Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
