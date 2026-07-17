import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/widgets/animated_card.dart';
import '../theme/widgets/luxury_background.dart';
import '../widgets/custom_app_bar.dart';

/// Reports section screen with financial summaries.
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final kpis = app.bootstrap?.kpis ?? {};

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: 'التقارير',
          subtitle: 'التقارير المالية والتشغيلية',
          showBack: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list_rounded,
                  color: AppColors.goldBright),
              onPressed: () {},
            ),
          ],
        ),
        body: LuxuryBackground(
          child: SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              children: [
                // Summary card
                _FinancialSummaryCard(kpis: kpis),
                const SizedBox(height: AppSpacing.sectionSpacing),

                // Report list
                Text(
                  'التقارير المتاحة',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.goldBright,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppSpacing.md),
                ..._reportItems.map(
                  (r) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _ReportTile(item: r),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static const _reportItems = [
    _ReportItem(
      icon: Icons.monetization_on_rounded,
      title: 'التقرير المالي الشهري',
      subtitle: 'يوليو 2025',
      accent: AppColors.success,
      status: 'جاهز',
    ),
    _ReportItem(
      icon: Icons.home_rounded,
      title: 'تقرير الإشغال',
      subtitle: 'Q2 2025',
      accent: AppColors.info,
      status: 'جاهز',
    ),
    _ReportItem(
      icon: Icons.build_rounded,
      title: 'تقرير الصيانة',
      subtitle: 'يوليو 2025',
      accent: AppColors.warning,
      status: 'جاهز',
    ),
    _ReportItem(
      icon: Icons.warning_rounded,
      title: 'تقرير المتأخرات',
      subtitle: 'يوليو 2025',
      accent: AppColors.danger,
      status: 'جاهز',
    ),
    _ReportItem(
      icon: Icons.description_rounded,
      title: 'تقرير العقود المنتهية',
      subtitle: 'Q3 2025',
      accent: AppColors.gold,
      status: 'قيد الإعداد',
    ),
    _ReportItem(
      icon: Icons.bar_chart_rounded,
      title: 'تقرير الأداء السنوي',
      subtitle: '2025',
      accent: AppColors.turquoise,
      status: 'قيد الإعداد',
    ),
  ];
}

class _FinancialSummaryCard extends StatelessWidget {
  const _FinancialSummaryCard({required this.kpis});
  final Map<String, dynamic> kpis;

  String _money(dynamic v) {
    final n = NumberFormat('#,##0.00', 'en_US')
        .format((v is num) ? v : double.tryParse('$v') ?? 0);
    return '$n OMR';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedCard(
      accent: AppColors.gold,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الملخص المالي',
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.goldBright,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _SummaryItem(
                label: 'الإيرادات',
                value: _money(kpis['income']),
                color: AppColors.success,
              ),
              const SizedBox(width: AppSpacing.base),
              _SummaryItem(
                label: 'المصروفات',
                value: _money(kpis['expense']),
                color: AppColors.danger,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(color: Color(0x26D4AF37)),
          const SizedBox(height: AppSpacing.sm),
          _SummaryItem(
            label: 'الصافي',
            value: _money(kpis['net']),
            color: AppColors.gold,
            large: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
    this.large = false,
  });
  final String label;
  final String value;
  final Color color;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
              ),
        ),
        Text(
          value,
          style: (large
                  ? Theme.of(context).textTheme.titleLarge
                  : Theme.of(context).textTheme.titleSmall)
              ?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _ReportItem {
  const _ReportItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.status,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final String status;
}

class _ReportTile extends StatelessWidget {
  const _ReportTile({required this.item});
  final _ReportItem item;

  @override
  Widget build(BuildContext context) {
    final ready = item.status == 'جاهز';
    return AnimatedCard(
      accent: item.accent,
      onTap: ready ? () {} : null,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Container(
            width: AppSpacing.avatarMd,
            height: AppSpacing.avatarMd,
            decoration: BoxDecoration(
              color: item.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(item.icon, color: item.accent, size: AppSpacing.iconSm),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(
                  item.subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: (ready ? AppColors.success : AppColors.warning)
                  .withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              border: Border.all(
                color: (ready ? AppColors.success : AppColors.warning)
                    .withValues(alpha: 0.35),
              ),
            ),
            child: Text(
              item.status,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: ready ? AppColors.success : AppColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(
            ready ? Icons.download_rounded : Icons.hourglass_empty_rounded,
            color: ready ? AppColors.textMuted : AppColors.textDisabled,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}
