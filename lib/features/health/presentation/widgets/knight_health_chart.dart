import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/design_system/knight_tokens.dart';
import '../../../../core/design_system/design_constants.dart';
import '../../../../core/intelligence/domain/health_visualization_models.dart';

enum ChartType { bar, line }

class KnightHealthChart extends StatelessWidget {
  const KnightHealthChart({
    super.key,
    required this.series,
    required this.type,
    this.height = 200,
  });

  final HealthChartSeries series;
  final ChartType type;
  final double height;

  @override
  Widget build(BuildContext context) {
    final color = _getMetricColor();
    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: KnightTokens.glass(accentColor: Colors.white, opacity: 0.02),
      child: type == ChartType.bar ? _buildBarChart(color) : _buildLineChart(color),
    );
  }

  Color _getMetricColor() {
    switch (series.metricType) {
      case 'steps': return const Color(0xFF0EA5E9);
      case 'heart_rate': return const Color(0xFFF43F5E);
      case 'calories': return const Color(0xFFF59E0B);
      case 'water': return const Color(0xFF3B82F6);
      case 'sleep_session': return const Color(0xFF818CF8);
      default: return const Color(0xFF0EA5E9);
    }
  }

  Widget _buildBarChart(Color color) {
    return BarChart(
      BarChartData(
        barGroups: series.dataPoints.map((p) => BarChartGroupData(
          x: p.x.toInt(),
          barRods: [
            BarChartRodData(
              toY: p.y,
              color: color,
              width: 12,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        )).toList(),
        gridData: const FlGridData(show: false),
        titlesData: _buildTitlesData(),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => DesignColors.surfaceHigh,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.toInt()} ${series.unit}',
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLineChart(Color color) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: series.dataPoints.map((p) => FlSpot(p.x, p.y)).toList(),
            isCurved: true,
            color: color,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: color.withValues(alpha: 0.1),
            ),
          ),
        ],
        gridData: const FlGridData(show: false),
        titlesData: _buildTitlesData(),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => DesignColors.surfaceHigh,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toInt()} ${series.unit}',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  FlTitlesData _buildTitlesData() {
    return const FlTitlesData(
      show: true,
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: 1,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 42,
        ),
      ),
    );
  }
}
