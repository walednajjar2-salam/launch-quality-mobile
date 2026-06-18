import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:launch_quality_mobile/app.dart';

void main() {
  testWidgets('App boots to login', (WidgetTester tester) async {
    await tester.pumpWidget(const LaunchQualityApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.textContaining('جودة الانطلاقة'), findsWidgets);
  });
}
