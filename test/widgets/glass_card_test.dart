import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:launch_quality_mobile/theme/widgets/glass_card.dart';
import 'package:launch_quality_mobile/theme/brand_colors.dart';

Widget _wrap(Widget child) => MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );

void main() {
  group('GlassCard', () {
    testWidgets('renders and displays child widget', (tester) async {
      await tester.pumpWidget(_wrap(
        const GlassCard(
          child: Text('Hello GlassCard'),
        ),
      ));

      expect(find.byType(GlassCard), findsOneWidget);
      expect(find.text('Hello GlassCard'), findsOneWidget);
    });

    testWidgets('renders with default gold accent', (tester) async {
      await tester.pumpWidget(_wrap(
        const GlassCard(child: Text('Default')),
      ));

      final widget = tester.widget<GlassCard>(find.byType(GlassCard));
      expect(widget.accent, BrandColors.gold);
    });

    testWidgets('applies custom accent color', (tester) async {
      await tester.pumpWidget(_wrap(
        const GlassCard(
          accent: BrandColors.danger,
          child: Text('Danger'),
        ),
      ));

      final widget = tester.widget<GlassCard>(find.byType(GlassCard));
      expect(widget.accent, BrandColors.danger);
    });

    testWidgets('renders without onTap (no InkWell)', (tester) async {
      await tester.pumpWidget(_wrap(
        const GlassCard(child: Text('No tap')),
      ));

      // When onTap is null the card should not wrap itself in InkWell.
      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('wraps with InkWell when onTap provided', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(_wrap(
        GlassCard(
          onTap: () => tapped = true,
          child: const Text('Tappable'),
        ),
      ));

      expect(find.byType(InkWell), findsOneWidget);
      await tester.tap(find.byType(GlassCard));
      expect(tapped, isTrue);
    });

    testWidgets('applies custom padding', (tester) async {
      const customPadding = EdgeInsets.all(32);

      await tester.pumpWidget(_wrap(
        const GlassCard(
          padding: customPadding,
          child: Text('Padded'),
        ),
      ));

      final widget = tester.widget<GlassCard>(find.byType(GlassCard));
      expect(widget.padding, customPadding);
    });

    testWidgets('renders complex child widget tree', (tester) async {
      await tester.pumpWidget(_wrap(
        const GlassCard(
          child: Column(
            children: [
              Text('Title'),
              SizedBox(height: 8),
              Text('Subtitle'),
            ],
          ),
        ),
      ));

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Subtitle'), findsOneWidget);
    });
  });

  // ─── KpiTile ──────────────────────────────────────────────────────────────
  group('KpiTile', () {
    testWidgets('renders label and value', (tester) async {
      await tester.pumpWidget(_wrap(
        const KpiTile(label: 'Projects', value: '42'),
      ));

      expect(find.text('Projects'), findsOneWidget);
      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(_wrap(
        const KpiTile(
          label: 'Clients',
          value: '10',
          icon: Icons.people,
        ),
      ));

      expect(find.byIcon(Icons.people), findsOneWidget);
    });

    testWidgets('renders without icon by default', (tester) async {
      await tester.pumpWidget(_wrap(
        const KpiTile(label: 'Count', value: '5'),
      ));

      // No explicit icon was provided.
      expect(find.byType(Icon), findsNothing);
    });
  });
}
