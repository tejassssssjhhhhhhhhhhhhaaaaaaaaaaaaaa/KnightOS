import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../providers/database_provider.dart';

class HealthTrackerService {
  HealthTrackerService({required this.db});
  final KnightDatabase db;

  Future<void> logConstipation(int bristolScale, {String? notes}) async {
    await db.healthTrackerDao.logTracker(HealthTrackerTableCompanion.insert(
      id: 'ct-${DateTime.now().millisecondsSinceEpoch}',
      trackerType: 'constipation',
      value: Value(bristolScale),
      notes: Value(notes),
    ));
  }

  Future<void> logPain(int level, {String? notes}) async {
    await db.healthTrackerDao.logTracker(HealthTrackerTableCompanion.insert(
      id: 'pain-${DateTime.now().millisecondsSinceEpoch}',
      trackerType: 'pain',
      value: Value(level),
      notes: Value(notes),
    ));
  }

  Future<void> logMood(int level, {String? notes}) async {
    await db.healthTrackerDao.logTracker(HealthTrackerTableCompanion.insert(
      id: 'mood-${DateTime.now().millisecondsSinceEpoch}',
      trackerType: 'mood',
      value: Value(level),
      notes: Value(notes),
    ));
  }

  Future<void> logWeight(double kg) async {
    await db.healthTrackerDao.logMeasurement(BodyMeasurementTableCompanion.insert(
      id: 'weight-${DateTime.now().millisecondsSinceEpoch}',
      measurementType: 'weight',
      value: kg,
      unit: 'kg',
    ));
  }
}

final healthTrackerServiceProvider = Provider<HealthTrackerService>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  return HealthTrackerService(db: db);
});
