import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:launch_quality_mobile/utils/layout_breakpoints.dart';

/// Helper that builds a minimal app with a given viewport size and lets the
/// test read `LayoutBreakpoints` values from inside a widget tree.
Widget _scaffold(double width, double height, Widget child) {
  return MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(size: Size(width, height)),
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  group('LayoutBreakpoints', () {
    // ─── isCompact ─────────────────────────────────────────────────────────
    group('isCompact', () {
      testWidgets('returns true for width < 600', (tester) async {
        bool? result;
        await tester.pumpWidget(_scaffold(
          599,
          800,
          Builder(builder: (ctx) {
            result = LayoutBreakpoints.isCompact(ctx);
            return const SizedBox.shrink();
          }),
        ));
        expect(result, isTrue);
      });

      testWidgets('returns false for width == 600', (tester) async {
        bool? result;
        await tester.pumpWidget(_scaffold(
          600,
          800,
          Builder(builder: (ctx) {
            result = LayoutBreakpoints.isCompact(ctx);
            return const SizedBox.shrink();
          }),
        ));
        expect(result, isFalse);
      });

      testWidgets('returns false for width > 600', (tester) async {
        bool? result;
        await tester.pumpWidget(_scaffold(
          900,
          800,
          Builder(builder: (ctx) {
            result = LayoutBreakpoints.isCompact(ctx);
            return const SizedBox.shrink();
          }),
        ));
        expect(result, isFalse);
      });
    });

    // ─── isDesktop ─────────────────────────────────────────────────────────
    group('isDesktop', () {
      testWidgets('returns false for width < 900', (tester) async {
        bool? result;
        await tester.pumpWidget(_scaffold(
          899,
          800,
          Builder(builder: (ctx) {
            result = LayoutBreakpoints.isDesktop(ctx);
            return const SizedBox.shrink();
          }),
        ));
        expect(result, isFalse);
      });

      testWidgets('returns true for width == 900', (tester) async {
        bool? result;
        await tester.pumpWidget(_scaffold(
          900,
          800,
          Builder(builder: (ctx) {
            result = LayoutBreakpoints.isDesktop(ctx);
            return const SizedBox.shrink();
          }),
        ));
        expect(result, isTrue);
      });

      testWidgets('returns true for width > 900', (tester) async {
        bool? result;
        await tester.pumpWidget(_scaffold(
          1440,
          900,
          Builder(builder: (ctx) {
            result = LayoutBreakpoints.isDesktop(ctx);
            return const SizedBox.shrink();
          }),
        ));
        expect(result, isTrue);
      });
    });

    // ─── gridColumns ───────────────────────────────────────────────────────
    group('gridColumns', () {
      testWidgets('returns 2 for compact width (< 600)', (tester) async {
        int? cols;
        await tester.pumpWidget(_scaffold(
          400,
          800,
          Builder(builder: (ctx) {
            cols = LayoutBreakpoints.gridColumns(ctx);
            return const SizedBox.shrink();
          }),
        ));
        expect(cols, 2);
      });

      testWidgets('returns 2 for tablet width (600 – 899)', (tester) async {
        int? cols;
        await tester.pumpWidget(_scaffold(
          700,
          800,
          Builder(builder: (ctx) {
            cols = LayoutBreakpoints.gridColumns(ctx);
            return const SizedBox.shrink();
          }),
        ));
        expect(cols, 2);
      });

      testWidgets('returns 3 for small desktop width (900 – 1199)',
          (tester) async {
        int? cols;
        await tester.pumpWidget(_scaffold(
          1000,
          800,
          Builder(builder: (ctx) {
            cols = LayoutBreakpoints.gridColumns(ctx);
            return const SizedBox.shrink();
          }),
        ));
        expect(cols, 3);
      });

      testWidgets('returns 4 for large desktop width (>= 1200)', (tester) async {
        int? cols;
        await tester.pumpWidget(_scaffold(
          1280,
          800,
          Builder(builder: (ctx) {
            cols = LayoutBreakpoints.gridColumns(ctx);
            return const SizedBox.shrink();
          }),
        ));
        expect(cols, 4);
      });
    });

    // ─── breakpoints relationship ───────────────────────────────────────────
    group('breakpoints relationship', () {
      final testWidths = [0.0, 300.0, 599.0, 600.0, 750.0, 899.0, 900.0, 1200.0, 2000.0];

      for (final width in testWidths) {
        testWidgets('compact and desktop are mutually exclusive at $width',
            (tester) async {
          bool? compact;
          bool? desktop;

          await tester.pumpWidget(_scaffold(
            width,
            800,
            Builder(builder: (ctx) {
              compact = LayoutBreakpoints.isCompact(ctx);
              desktop = LayoutBreakpoints.isDesktop(ctx);
              return const SizedBox.shrink();
            }),
          ));

          // They cannot both be true simultaneously.
          expect(compact! && desktop!, isFalse,
              reason: 'Both compact and desktop true at width $width');
        });
      }
    });
  });
}
