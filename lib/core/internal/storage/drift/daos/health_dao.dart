import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/health_metrics.dart';

part 'health_dao.g.dart';

@DriftAccessor(tables: [HealthMetricTable])
class HealthDao extends DatabaseAccessor<KnightDatabase> with _$HealthDaoMixin {
  HealthDao(super.db);

  Future<List<HealthMetricData>> getLatestMetrics(String type, {int limit = 1}) {
    return (select(healthMetricTable)
          ..where((t) => t.metricType.equals(type))
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)])
          ..limit(limit))
        .get();
  }

  Future<List<HealthMetricData>> getMetricsInRange(String type, DateTime start, DateTime end) {
    return (select(healthMetricTable)
          ..where((t) => t.metricType.equals(type))
          ..where((t) => t.startTime.isBetweenValues(start, end))
          ..orderBy([(t) => OrderingTerm.asc(t.startTime)]))
        .get();
  }

  Future<void> insertMetrics(List<HealthMetricTableCompanion> metrics) async {
    await batch((batch) {
      batch.insertAll(healthMetricTable, metrics, mode: InsertMode.insertOrReplace);
    });
  }

  Future<double> getDailyTotal(String type, DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    
    final query = select(healthMetricTable)
      ..where((t) => t.metricType.equals(type))
      ..where((t) => t.startTime.isBetweenValues(start, end));
      
    final results = await query.get();
    double total = 0.0;
    for (final m in results) {
      total += m.value;
    }
    return total;
  }
}
