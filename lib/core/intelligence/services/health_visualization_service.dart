import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../providers/database_provider.dart';
import '../domain/health_visualization_models.dart';
import 'package:drift/drift.dart';

class HealthVisualizationService {
  HealthVisualizationService({required this.db});
  final KnightDatabase db;

  Future<HealthChartSeries> getSeries({
    required String metricType,
    required ChartTimePeriod period,
    required DateTime endDate,
  }) async {
    final DateTime startDate = _calculateStartDate(period, endDate);
    
    final query = db.select(db.healthMetricTable)
      ..where((t) => t.metricType.equals(metricType))
      ..where((t) => t.startTime.isBetweenValues(startDate, endDate))
      ..orderBy([(t) => OrderingTerm.asc(t.startTime)]);
      
    final metrics = await query.get();
    
    final dataPoints = _aggregateData(metrics, period, startDate);
    
    return HealthChartSeries(
      metricType: metricType,
      dataPoints: dataPoints,
      unit: metrics.isNotEmpty ? metrics.first.unit : '',
    );
  }

  DateTime _calculateStartDate(ChartTimePeriod period, DateTime endDate) {
    switch (period) {
      case ChartTimePeriod.day:
        return DateTime(endDate.year, endDate.month, endDate.day);
      case ChartTimePeriod.week:
        return endDate.subtract(const Duration(days: 7));
      case ChartTimePeriod.month:
        return DateTime(endDate.year, endDate.month - 1, endDate.day);
      case ChartTimePeriod.year:
        return DateTime(endDate.year - 1, endDate.month, endDate.day);
    }
  }

  List<HealthChartDataPoint> _aggregateData(
    List<HealthMetricData> metrics,
    ChartTimePeriod period,
    DateTime startDate,
  ) {
    if (metrics.isEmpty) return [];

    final Map<int, double> grouped = {};
    
    for (final m in metrics) {
      final key = _getGroupKey(m.startTime, period, startDate);
      grouped[key] = (grouped[key] ?? 0) + m.value;
    }

    return grouped.entries.map((e) => HealthChartDataPoint(
      x: e.key.toDouble(),
      y: e.value,
    )).toList()..sort((a, b) => a.x.compareTo(b.x));
  }

  int _getGroupKey(DateTime time, ChartTimePeriod period, DateTime startDate) {
    switch (period) {
      case ChartTimePeriod.day:
        return time.hour;
      case ChartTimePeriod.week:
        return time.difference(startDate).inDays;
      case ChartTimePeriod.month:
        return time.difference(startDate).inDays;
      case ChartTimePeriod.year:
        return time.month;
    }
  }
}

final healthVisualizationServiceProvider = Provider<HealthVisualizationService>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  return HealthVisualizationService(db: db);
});
