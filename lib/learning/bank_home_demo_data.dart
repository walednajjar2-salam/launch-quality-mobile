/// بيانات تجريبية قابلة للتعديل — لأغراض التعلم فقط.
/// غيّر القيم هنا ثم أعد تشغيل التطبيق لترى النتيجة.
class BankHomeDemoData {
  /// الرصيد المعروض على الشاشة الرئيسية.
  static const double balance = 7034.340;

  /// اسم صاحب الحساب.
  static const String userName = 'WALEED MOHAMMED ABDUL HADI AL NAJJAR';

  /// نوع الحساب وآخر أرقام.
  static const String accountLabel = 'حساب التوفير - 0101';

  /// عنوان قسم الرصيد.
  static const String balanceTitle = 'الرصيد في الحساب';

  /// عملة العرض.
  static const String currency = 'OMR';

  /// أزرار الإجراءات السريعة.
  static const String moneyAction = 'مالي';
  static const String goalsAction = 'أهدافي';

  /// نص البنر الترويجي.
  static const String promoTitle = 'بطاقة الخصم المباشر';
  static const String promoSubtitle = 'استمتع بخصومات حصرية عند الدفع';

  /// قسم المعاملات.
  static const String transactionsTitle = 'المعاملات المالية';
  static const String viewAllLabel = 'مشاهدة الكل';
  static const String viewDetailsLabel = 'مشاهدة التفاصيل';

  /// قائمة معاملات وهمية للتعلّم.
  static const List<DemoTransaction> transactions = [
    DemoTransaction(
      title: 'تحويل وارد',
      subtitle: 'من حساب ادخار',
      amount: 50.000,
      isCredit: true,
      date: '18 يوليو',
    ),
    DemoTransaction(
      title: 'شراء نقطة بيع',
      subtitle: 'متجر تجريبي',
      amount: 12.250,
      isCredit: false,
      date: '17 يوليو',
    ),
    DemoTransaction(
      title: 'دفعة فاتورة',
      subtitle: 'خدمات',
      amount: 5.000,
      isCredit: false,
      date: '16 يوليو',
    ),
  ];
}

class DemoTransaction {
  const DemoTransaction({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isCredit,
    required this.date,
  });

  final String title;
  final String subtitle;
  final double amount;
  final bool isCredit;
  final String date;
}
