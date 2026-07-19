import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/widgets/animated_card.dart';
import '../theme/widgets/luxury_background.dart';
import '../widgets/custom_app_bar.dart';

/// Analytics dashboard screen with performance metrics.
class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _selectedPeriod = 0;
  static const _periods = ['هذا الشهر', 'هذا الربع', 'هذا العام'];

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final kpis = app.bootstrap?.kpis ?? {};
    final occupancy = (kpis['occupancy'] is num)
        ? (kpis['occupancy'] as num).toDouble()
        : double.tryParse('${kpis['occupancy']}') ?? 78.0;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: 'التحليلات',
          subtitle: 'مؤشرات الأداء',
          showBack: true,
        ),
        body: LuxuryBackground(
          child: SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              children: [
                // Period selector
                _PeriodSelector(
                  periods: _periods,
                  selected: _selectedPeriod,
                  onSelect: (i) => setState(() => _selectedPeriod = i),
                ),
                const SizedBox(height: AppSpacing.sectionSpacing),

                // Occupancy
                _OccupancyCard(occupancy: occupancy),
                const SizedBox(height: AppSpacing.sectionSpacing),

                // Performance metrics
                Text(
                  'مؤشرات الأداء',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.goldBright,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppSpacing.md),
                ..._performanceMetrics(kpis).map(
                  (m) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _MetricRow(metric: m),
                  ),
                ),
                const SizedBox(height: AppSpacing.sectionSpacing),

                // Revenue breakdown
                Text(
                  'توزيع الإيرادات',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.goldBright,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppSpacing.md),
                const _RevenueBreakdown(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<_MetricData> _performanceMetrics(Map<String, dynamic> kpis) => [
        _MetricData(
          label: 'نسبة التحصيل',
          value: 87.5,
          maxValue: 100,
          unit: '%',
          color: AppColors.success,
          icon: Icons.payments_rounded,
        ),
        _MetricData(
          label: 'رضا المستأجرين',
          value: 4.2,
          maxValue: 5,
          unit: '/5',
          color: AppColors.gold,
          icon: Icons.star_rounded,
        ),
        _MetricData(
          label: 'صيانة مغلقة',
          value: 73,
          maxValue: 100,
          unit: '%',
          color: AppColors.turquoise,
          icon: Icons.build_rounded,
        ),
        _MetricData(
          label: 'تجديد العقود',
          value: 68,
          maxValue: 100,
          unit: '%',
          color: AppColors.info,
          icon: Icons.description_rounded,
        ),
      ];
}

// ── Sub-widgets ────────────────────────────────────────────────────────────

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({
    required this.periods,
    required this.selected,
    required this.onSelect,
  });
  final List<String> periods;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(periods.length, (i) {
        final isSelected = i == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.gold.withValues(alpha: 0.15)
                    : AppColors.panel.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: isSelected
                      ? AppColors.gold.withValues(alpha: 0.4)
                      : AppColors.gold.withValues(alpha: 0.1),
                ),
              ),
              child: Text(
                periods[i],
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: isSelected
                          ? AppColors.goldBright
                          : AppColors.textMuted,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _OccupancyCard extends StatelessWidget {
  const _OccupancyCard({required this.occupancy});
  final double occupancy;

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      accent: AppColors.turquoise,
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: occupancy / 100,
                  strokeWidth: 8,
                  backgroundColor: AppColors.turquoise.withValues(alpha: 0.15),
                  valueColor:
                      const AlwaysStoppedAnimation(AppColors.turquoise),
                ),
                Text(
                  '${occupancy.toInt()}%',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.turquoise,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'نسبة الإشغال',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'معدل إشغال الوحدات العقارية',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    const Icon(Icons.trending_up, color: AppColors.success, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '+2.1% مقارنة بالشهر السابق',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.success,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricData {
  const _MetricData({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.unit,
    required this.color,
    required this.icon,
  });
  final String label;
  final double value;
  final double maxValue;
  final String unit;
  final Color color;
  final IconData icon;
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.metric});
  final _MetricData metric;

  @override
  Widget build(BuildContext context) {
    final progress = (metric.value / metric.maxValue).clamp(0.0, 1.0);
    return AnimatedCard(
      accent: metric.color,
      padding: const EdgeInsets.all(AppSpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(metric.icon, color: metric.color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  metric.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                ),
              ),
              Text(
                '${metric.value}${metric.unit}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: metric.color,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: metric.color.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation(metric.color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _RevenueBreakdown extends StatelessWidget {
  const _RevenueBreakdown();

  static const _items = [
    _BreakdownItem(label: 'إيجارات سكنية', percent: 62, color: AppColors.gold),
    _BreakdownItem(label: 'إيجارات تجارية', percent: 24, color: AppColors.info),
    _BreakdownItem(label: 'خدمات ومرافق', percent: 9, color: AppColors.success),
    _BreakdownItem(label: 'متأخرات محصّلة', percent: 5, color: AppColors.warning),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      accent: AppColors.gold,
      child: Column(
        children: _items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: item.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        item.label,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                      ),
                    ),
                    Text(
                      '${item.percent}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: item.color,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  child: LinearProgressIndicator(
                    value: item.percent / 100,
                    backgroundColor: item.color.withValues(alpha: 0.12),
                    valueColor: AlwaysStoppedAnimation(item.color),
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _BreakdownItem {
  const _BreakdownItem({
    required this.label,
    required this.percent,
    required this.color,
  });
  final String label;
  final int percent;
  final Color color;
}
