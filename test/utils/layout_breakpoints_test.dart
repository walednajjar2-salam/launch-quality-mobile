import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launch_quality_mobile/utils/layout_breakpoints.dart';

void main() {
  Future<void> pumpWithWidth(WidgetTester tester, double width) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(width, 800)),
          child: Builder(
            builder: (context) {
              return Column(
                children: [
                  Text('mobile:${LayoutBreakpoints.isMobile(context)}'),
                  Text('tablet:${LayoutBreakpoints.isTablet(context)}'),
                  Text('desktop:${LayoutBreakpoints.isDesktop(context)}'),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  group('LayoutBreakpoints', () {
    testWidgets('detects mobile layout for widths less than 600', (tester) async {
      await pumpWithWidth(tester, 599);
      expect(find.text('mobile:true'), findsOneWidget);
    });

    testWidgets('detects tablet layout for widths between 600 and 900', (tester) async {
      await pumpWithWidth(tester, 700);
      expect(find.text('tablet:true'), findsOneWidget);
    });

    testWidgets('detects desktop layout for widths 900 and above', (tester) async {
      await pumpWithWidth(tester, 900);
      expect(find.text('desktop:true'), findsOneWidget);
    });

    testWidgets('edge cases 0, 600, 900, 2000', (tester) async {
      await pumpWithWidth(tester, 0);
      expect(find.text('mobile:true'), findsOneWidget);

      await pumpWithWidth(tester, 600);
      expect(find.text('tablet:true'), findsOneWidget);

      await pumpWithWidth(tester, 900);
      expect(find.text('desktop:true'), findsOneWidget);

      await pumpWithWidth(tester, 2000);
      expect(find.text('desktop:true'), findsOneWidget);
    });
  });
}
