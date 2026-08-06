import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/design_system/knight_tokens.dart';
import '../../domain/finance_analytics_models.dart';

class IntelligenceModuleCard extends StatelessWidget {
  const IntelligenceModuleCard({
    super.key,
    required this.title,
    required this.child,
    this.onTap,
  });

  final String title;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: KnightTokens.radiusCard,
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title.toUpperCase(), style: KnightTokens.label),
              const Spacer(),
              if (onTap != null)
                IconButton(
                  onPressed: onTap,
                  icon: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.white24),
                ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class SpendingPieChart extends StatelessWidget {
  const SpendingPieChart({super.key, required this.data});
  final Map<String, double> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const Text('No spending data available.', style: TextStyle(color: Colors.white10));

    final total = data.values.fold(0.0, (sum, v) => sum + v);
    final sortedEntries = data.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final top5 = sortedEntries.take(5).toList();

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: top5.map((e) {
                final index = top5.indexOf(e);
                return PieChartSectionData(
                  value: e.value,
                  title: '',
                  radius: 40,
                  color: _getChartColor(index),
                );
              }).toList(),
              sectionsSpace: 4,
              centerSpaceRadius: 40,
            ),
          ),
        ),
        const SizedBox(height: 24),
        ...top5.map((e) {
          final index = top5.indexOf(e);
          final percentage = total > 0 ? (e.value / total * 100).toInt() : 0;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: _getChartColor(index), shape: BoxShape.circle)),
                const SizedBox(width: 12),
                Text(e.key, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                const Spacer(),
                Text('$percentage%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white38)),
              ],
            ),
          );
        }),
      ],
    );
  }

  Color _getChartColor(int index) {
    const colors = [Colors.blueAccent, Colors.orangeAccent, Colors.purpleAccent, Colors.cyanAccent, Colors.redAccent];
    return colors[index % colors.length];
  }
}

class InsightTile extends StatelessWidget {
  const InsightTile({super.key, required this.insight});
  final FinanceInsight insight;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, size: 14, color: Colors.blueAccent),
              const SizedBox(width: 12),
              Text(insight.title.toUpperCase(), style: KnightTokens.label.copyWith(fontSize: 8, color: Colors.blueAccent)),
            ],
          ),
          const SizedBox(height: 8),
          Text(insight.message, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white70)),
          const SizedBox(height: 4),
          Text(insight.impact, style: const TextStyle(fontSize: 12, color: Colors.white38)),
        ],
      ),
    );
  }
}

class MerchantIntelligenceList extends StatelessWidget {
  const MerchantIntelligenceList({super.key, required this.merchants});
  final List<MerchantIntelligence> merchants;

  @override
  Widget build(BuildContext context) {
    if (merchants.isEmpty) return const Text('No merchant data found.');
    return Column(
      children: merchants.map((m) => _MerchantTile(m: m)).toList(),
    );
  }
}

class _MerchantTile extends StatelessWidget {
  const _MerchantTile({required this.m});
  final MerchantIntelligence m;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m.merchant, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text('${m.frequency} visits · Avg: ₹${m.averagePurchase.toStringAsFixed(0)}', style: const TextStyle(fontSize: 10, color: Colors.white24)),
              ],
            ),
          ),
          Text('₹${m.lifetimeSpend.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white70)),
        ],
      ),
    );
  }
}

class CategoryIntelligenceList extends StatelessWidget {
  const CategoryIntelligenceList({super.key, required this.categories});
  final List<CategoryIntelligence> categories;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const Text('No category data found.');
    return Column(
      children: categories.map((c) => _CategoryTile(c: c)).toList(),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.c});
  final CategoryIntelligence c;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(c.category.toUpperCase(), style: KnightTokens.label.copyWith(fontSize: 8)),
              const Spacer(),
              Text('₹${c.lifetimeSpend.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 4),
          Text('Avg Monthly: ₹${c.averageMonthlySpend.toStringAsFixed(0)}', style: const TextStyle(fontSize: 10, color: Colors.white24)),
        ],
      ),
    );
  }
}

class TrendSparkline extends StatelessWidget {
  const TrendSparkline({super.key, required this.points, required this.color});
  final List<TrendPoint> points;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) return const Text('Waiting for more data to generate trends...', style: TextStyle(color: Colors.white10, fontSize: 10));

    return SizedBox(
      height: 100,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: points.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.value)).toList(),
              isCurved: true,
              color: color,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: true, color: color.withValues(alpha: 0.1)),
            ),
          ],
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
