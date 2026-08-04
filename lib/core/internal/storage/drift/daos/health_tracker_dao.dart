import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/health_trackers.dart';
import '../tables/body_measurements.dart';

part 'health_tracker_dao.g.dart';

@DriftAccessor(tables: [HealthTrackerTable, BodyMeasurementTable])
class HealthTrackerDao extends DatabaseAccessor<KnightDatabase> with _$HealthTrackerDaoMixin {
  HealthTrackerDao(super.db);

  Future<void> logTracker(HealthTrackerTableCompanion entry) =>
      into(healthTrackerTable).insert(entry);

  Future<List<HealthTrackerData>> getTrackerHistory(String type, {int limit = 30}) {
    return (select(healthTrackerTable)
          ..where((t) => t.trackerType.equals(type))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
          ..limit(limit))
        .get();
  }

  Future<void> logMeasurement(BodyMeasurementTableCompanion entry) =>
      into(bodyMeasurementTable).insert(entry);

  Future<List<BodyMeasurementData>> getMeasurementHistory(String type, {int limit = 10}) {
    return (select(bodyMeasurementTable)
          ..where((t) => t.measurementType.equals(type))
          ..orderBy([(t) => OrderingTerm.desc(t.measuredAt)])
          ..limit(limit))
        .get();
  }
}
