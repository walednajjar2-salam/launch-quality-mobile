import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/bootstrap_service.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/layout_breakpoints.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key, required this.data});

  final BootstrapData data;

  @override
  Widget build(BuildContext context) {
    final k = data.kpis;
    final series = List<Map<String, dynamic>>.from(
      data.dashboard['series'] as List? ?? [],
    );

    return RefreshIndicator(
      color: BrandColors.gold,
      onRefresh: () => context.read<AppState>().refresh(),
      child: ListView(
        padding: EdgeInsets.all(LayoutBreakpoints.isDesktop(context) ? 24 : 16),
        children: [
          LayoutBuilder(
            builder: (context, c) {
              final cols = LayoutBreakpoints.gridColumns(context);
              return GridView.count(
                crossAxisCount: cols.clamp(2, 4),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  KpiTile(
                    label: 'الإيرادات',
                    value: money(k['income']),
                    icon: Icons.arrow_upward_rounded,
                    accent: BrandColors.success,
                    valueColor: BrandColors.success,
                  ),
                  KpiTile(
                    label: 'المصروفات',
                    value: money(k['expense']),
                    icon: Icons.arrow_downward_rounded,
                    accent: BrandColors.danger,
                    valueColor: BrandColors.danger,
                  ),
                  KpiTile(
                    label: 'الأرباح',
                    value: money(k['net']),
                    icon: Icons.account_balance_wallet_outlined,
                    accent: BrandColors.gold,
                  ),
                  KpiTile(
                    label: 'المحصّل',
                    value: money(k['paid']),
                    icon: Icons.payments_outlined,
                    accent: BrandColors.turquoise,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          GlassCard(
            accent: BrandColors.turquoise,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الأداء الشهري',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: BrandColors.goldBright,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: LayoutBreakpoints.isDesktop(context) ? 280 : 220,
                  child: series.isEmpty
                      ? const EmptyState(message: 'لا توجد بيانات شهرية')
                      : _FinanceChart(series: series),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FinanceChart extends StatelessWidget {
  const _FinanceChart({required this.series});

  final List<Map<String, dynamic>> series;

  @override
  Widget build(BuildContext context) {
    final incomeSpots = <FlSpot>[];
    final expenseSpots = <FlSpot>[];
    for (var i = 0; i < series.length; i++) {
      final row = series[i];
      incomeSpots.add(FlSpot(i.toDouble(), _num(row['income'])));
      expenseSpots.add(FlSpot(i.toDouble(), _num(row['expense'])));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (v) => FlLine(
            color: BrandColors.gold.withValues(alpha: 0.08),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 42,
              getTitlesWidget: (v, _) => Text(
                v.toInt().toString(),
                style: TextStyle(color: BrandColors.textMuted, fontSize: 10),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) {
                final i = v.toInt();
                if (i < 0 || i >= series.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '${series[i]['month'] ?? ''}',
                    style: TextStyle(color: BrandColors.textMuted, fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: incomeSpots,
            isCurved: true,
            color: BrandColors.success,
            barWidth: 3,
            dotData: const FlDotData(show: false),
          ),
          LineChartBarData(
            spots: expenseSpots,
            isCurved: true,
            color: BrandColors.danger,
            barWidth: 3,
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  double _num(dynamic v) => (v is num) ? v.toDouble() : double.tryParse('$v') ?? 0;
}
