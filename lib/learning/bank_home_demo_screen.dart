import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'bank_home_demo_data.dart';

/// واجهة رئيسية تجريبية مطابقة للصورة — للتعلّم فقط.
class BankHomeDemoScreen extends StatefulWidget {
  const BankHomeDemoScreen({super.key});

  @override
  State<BankHomeDemoScreen> createState() => _BankHomeDemoScreenState();
}

class _BankHomeDemoScreenState extends State<BankHomeDemoScreen> {
  static const _bg = Color(0xFF001A33);
  static const _orange = Color(0xFFFF8C00);
  static const _bronze = Color(0xFF6B4A2A);
  static const _link = Color(0xFF9EC9FF);

  bool _visible = true;
  int _nav = 0;
  late double _balance;
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _balance = BankHomeDemoData.balance;
    _ctrl = TextEditingController(text: _balance.toStringAsFixed(3));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _editBalance() async {
    _ctrl.text = _balance.toStringAsFixed(3);
    final ok = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: const Color(0xFF0B243F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.viewInsetsOf(ctx).bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('تعديل الرصيد (تعلّم)', style: TextStyle(color: _orange, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            TextField(
              controller: _ctrl,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0x4D000000),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onSubmitted: (_) => Navigator.pop(ctx, true),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('إلغاء'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: _orange, foregroundColor: _bg),
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('تطبيق'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    if (ok != true || !mounted) return;
    final v = double.tryParse(_ctrl.text.trim());
    if (v == null || v < 0) return;
    setState(() {
      _balance = double.parse(v.toStringAsFixed(3));
      _visible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: _bg,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _statusBar(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                    children: [
                      _header(),
                      const SizedBox(height: 16),
                      _balanceCard(),
                      const SizedBox(height: 10),
                      _dots(active: 0),
                      const SizedBox(height: 14),
                      _quickBar(),
                      const SizedBox(height: 14),
                      _promo(),
                      const SizedBox(height: 8),
                      _dots(active: 0),
                      const SizedBox(height: 8),
                      _txBox(),
                    ],
                  ),
                ),
                _bottomNav(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusBar() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 6, 20, 0),
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
            Icon(Icons.battery_4_bar, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Expanded(
          child: RichText(
            textAlign: TextAlign.right,
            text: TextSpan(
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700, height: 1.35),
              children: [
                TextSpan(text: '${BankHomeDemoData.greeting} '),
                TextSpan(
                  text: BankHomeDemoData.userName,
                  style: const TextStyle(fontSize: 12, letterSpacing: 0.2),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _orange,
            shape: BoxShape.circle,
            boxShadow: const [BoxShadow(color: Color(0x59FF8C00), blurRadius: 8, offset: Offset(0, 2))],
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 22),
        ),
      ],
    );
  }

  Widget _balanceCard() {
    final fixed = _balance.toStringAsFixed(3);
    final parts = fixed.split('.');
    final intFmt = NumberFormat('#,##0', 'en_US').format(int.parse(parts[0]));

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0x1CFFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  BankHomeDemoData.balanceTitle,
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Color(0xE0FFFFFF), fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _visible = !_visible),
                icon: Icon(_visible ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onLongPress: _editBalance,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: _visible
                    ? Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: intFmt,
                              style: const TextStyle(color: _orange, fontSize: 36, fontWeight: FontWeight.w800, height: 1),
                            ),
                            TextSpan(
                              text: '.${parts[1]} ${BankHomeDemoData.currency}',
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600, height: 1),
                            ),
                          ],
                        ),
                      )
                    : const Text(
                        '•••• ••• OMR',
                        style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.download_outlined, color: Colors.white70, size: 16),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        BankHomeDemoData.accountLabel,
                        style: const TextStyle(color: Color(0xD9FFFFFF), fontSize: 12.5, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                BankHomeDemoData.detailsLabel,
                style: const TextStyle(color: _link, fontSize: 12.5, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dots({required int active}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (i) {
        return Container(
          width: 7,
          height: 7,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i == active ? Colors.white : const Color(0x47FFFFFF),
          ),
        );
      }),
    );
  }

  Widget _quickBar() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF7A5530), _bronze, Color(0xFF5A3D22)],
        ),
        boxShadow: const [BoxShadow(color: Color(0x40000000), blurRadius: 10, offset: Offset(0, 3))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shield_outlined, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(BankHomeDemoData.moneyLabel, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
              ],
            ),
          ),
          Container(width: 1, height: 32, color: const Color(0x8CFFFFFF)),
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.emoji_events_outlined, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text(BankHomeDemoData.goalsLabel, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                    ],
                  ),
                ),
                Positioned(
                  top: 4,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: _orange, borderRadius: BorderRadius.circular(8)),
                    child: const Text('NEW', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _promo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x2E000000), blurRadius: 14, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(BankHomeDemoData.promoTitle, style: const TextStyle(color: Color(0xFF0D2340), fontWeight: FontWeight.w800, fontSize: 13)),
                const SizedBox(height: 4),
                Text(BankHomeDemoData.promoSubtitle, style: const TextStyle(color: Color(0xFF5A6D82), fontSize: 11, height: 1.35)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 86,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(colors: [Color(0xFF0B2A4D), Color(0xFF1E4E82), Color(0xFFFF8C00)]),
            ),
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(6),
            child: const Text('BANK', style: TextStyle(color: Colors.white70, fontSize: 8, letterSpacing: 1)),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: _orange, borderRadius: BorderRadius.circular(18)),
            child: Text(BankHomeDemoData.orderNow, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _txBox() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
      decoration: BoxDecoration(
        color: const Color(0xFF0A2744),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x0FFFFFFF)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              BankHomeDemoData.txTitle,
              style: const TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w800),
            ),
          ),
          Text(BankHomeDemoData.viewAll, style: const TextStyle(color: _orange, fontSize: 12.5, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _bottomNav() {
    const items = [
      (Icons.home_outlined, 'الرئيسية'),
      (Icons.credit_card_outlined, 'البطاقات'),
      (Icons.swap_horiz, 'التحويلات'),
      (Icons.receipt_long_outlined, 'المدفوعات'),
      (Icons.menu, 'المزيد'),
    ];
    return Container(
      padding: EdgeInsets.fromLTRB(0, 8, 0, 8 + MediaQuery.paddingOf(context).bottom),
      decoration: const BoxDecoration(
        color: Color(0xFF001528),
        border: Border(top: BorderSide(color: Color(0x1FFFFFFF))),
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _nav = i),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(items[i].$1, color: _nav == i ? _orange : Colors.white54, size: 22),
                    const SizedBox(height: 3),
                    Text(
                      items[i].$2,
                      style: TextStyle(
                        color: _nav == i ? _orange : Colors.white54,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
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
