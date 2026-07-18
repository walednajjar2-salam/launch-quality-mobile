import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'bank_home_demo_data.dart';

/// شاشة رئيسية بنكية تجريبية مطابقة تقريبياً للصورة — لأغراض التعلّم فقط.
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
    if (!_balanceVisible) return '•••••• ${BankHomeDemoData.currency}';
    return '${_amountFmt.format(_balance)} ${BankHomeDemoData.currency}';
  }

  Future<void> _openBalanceEditor() async {
    _balanceController.text = _balance.toStringAsFixed(3);
    final applied = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: const Color(0xFF12243C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            16 + MediaQuery.viewInsetsOf(ctx).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'تعديل الرصيد (تعلّم)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFF28C28),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _balanceController,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                decoration: InputDecoration(
                  labelText: 'الرصيد',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0x44000000),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0x33FFFFFF)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFF28C28)),
                  ),
                ),
                onSubmitted: (_) => Navigator.pop(ctx, true),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(44),
                      ),
                      child: const Text('إلغاء'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFF28C28),
                        foregroundColor: const Color(0xFF12263F),
                        minimumSize: const Size.fromHeight(44),
                      ),
                      child: const Text('تطبيق', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (applied != true || !mounted) return;
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFF071A33),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0A2344), Color(0xFF071A33), Color(0xFF061325)],
                stops: [0, 0.42, 1],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  _buildStatusBar(),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 6, 16, 18),
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 14),
                        _buildBalanceCard(),
                        const SizedBox(height: 14),
                        _buildQuickActions(),
                        const SizedBox(height: 14),
                        _buildPromoBanner(),
                        const SizedBox(height: 18),
                        _buildTransactionsHeader(),
                        const SizedBox(height: 24),
                        const Text(
                          'لا توجد معاملات للعرض',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0x73FFFFFF), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  _buildBottomNav(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(22, 4, 22, 0),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          children: [
            Text('6:37', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
            Spacer(),
            Icon(Icons.signal_cellular_alt, color: Colors.white, size: 16),
            SizedBox(width: 4),
            Text('4G', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
            SizedBox(width: 6),
            Icon(Icons.battery_full, color: Colors.white, size: 18),
          ],
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
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
        ),
        const SizedBox(width: 10),
        _roundIcon(Icons.notifications_none),
        const SizedBox(width: 8),
        _roundIcon(Icons.person_outline),
      ],
    );
  }

  Widget _roundIcon(IconData icon) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: const Color(0x14FFFFFF),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF243952), Color(0xFF1A2D45), Color(0xFF15263C)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x14FFFFFF)),
        boxShadow: const [
          BoxShadow(color: Color(0x2E000000), blurRadius: 24, offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            BankHomeDemoData.balanceTitle,
            textAlign: TextAlign.right,
            style: const TextStyle(color: Color(0xD1FFFFFF), fontSize: 13),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onLongPress: _openBalanceEditor,
                  child: Text(
                    _formattedBalance,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Color(0xFFF28C28),
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      height: 1.05,
                    ),
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
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Colors.white70, fontSize: 12.5),
                ),
              ),
              Text(
                BankHomeDemoData.viewDetailsLabel,
                style: const TextStyle(
                  color: Color(0xFFFF9A3C),
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                  decorationColor: Color(0xFFFF9A3C),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(child: _actionButton(BankHomeDemoData.moneyAction)),
        const SizedBox(width: 10),
        Expanded(child: _actionButton(BankHomeDemoData.goalsAction)),
      ],
    );
  }

  Widget _actionButton(String label) {
    return Container(
      height: 46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF9A6634), Color(0xFF8B5A2B), Color(0xFF6E4520)],
        ),
        boxShadow: const [
          BoxShadow(color: Color(0x33000000), offset: Offset(0, 2)),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Color(0x1F000000), blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 78,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                colors: [Color(0xFF1A3355), Color(0xFF2A4D78), Color(0xFFF28C28)],
              ),
            ),
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(6),
            child: const Text(
              '•••• 0101',
              style: TextStyle(color: Colors.white70, fontSize: 8, letterSpacing: 0.5),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  BankHomeDemoData.promoTitle,
                  style: const TextStyle(
                    color: Color(0xFF13233A),
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  BankHomeDemoData.promoSubtitle,
                  style: const TextStyle(color: Color(0xFF5B6D82), fontSize: 11.5, height: 1.35),
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
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Text(
          BankHomeDemoData.viewAllLabel,
          style: const TextStyle(
            color: Color(0xFFF28C28),
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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
      padding: EdgeInsets.fromLTRB(2, 8, 2, 8 + MediaQuery.paddingOf(context).bottom),
      decoration: const BoxDecoration(
        color: Color(0xF5061527),
        border: Border(top: BorderSide(color: Color(0x14FFFFFF))),
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
                      color: _navIndex == i ? const Color(0xFFF28C28) : Colors.white54,
                      size: 22,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      items[i].$2,
                      style: TextStyle(
                        color: _navIndex == i ? const Color(0xFFF28C28) : Colors.white54,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
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
