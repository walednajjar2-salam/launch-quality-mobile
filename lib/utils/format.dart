import 'package:intl/intl.dart';

String money(num? value) {
  final n = NumberFormat('#,##0.00', 'en_US').format(value ?? 0);
  return '$n OMR';
}
