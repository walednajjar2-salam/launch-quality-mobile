import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launch_quality_mobile/theme/app_theme.dart';

void main() {
  group('GlassCard', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassCard(
              child: Text('child-content'),
            ),
          ),
        ),
      );

      expect(find.text('child-content'), findsOneWidget);
    });

    testWidgets('contains blur effect', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassCard(
              child: SizedBox.shrink(),
            ),
          ),
        ),
      );

      final filter = tester.widget<BackdropFilter>(find.byType(BackdropFilter));
      expect(filter.filter, isA<ImageFilter>());
    });

    testWidgets('supports custom accent and padding', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassCard(
              accent: Colors.red,
              padding: EdgeInsets.all(8),
              child: Text('custom'),
            ),
          ),
        ),
      );

      expect(find.text('custom'), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('supports tap callback', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassCard(
              onTap: () => tapped = true,
              child: const Text('tap-me'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('tap-me'));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}
