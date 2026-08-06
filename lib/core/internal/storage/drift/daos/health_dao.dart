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
    
    // P0: SQL aggregation for performance
    final query = selectOnly(healthMetricTable)
      ..addColumns([healthMetricTable.value.sum()])
      ..where(healthMetricTable.metricType.equals(type))
      ..where(healthMetricTable.startTime.isBetweenValues(start, end));
      
    final result = await query.map((row) => row.read(healthMetricTable.value.sum())).getSingle();
    return result ?? 0.0;
  }
}
