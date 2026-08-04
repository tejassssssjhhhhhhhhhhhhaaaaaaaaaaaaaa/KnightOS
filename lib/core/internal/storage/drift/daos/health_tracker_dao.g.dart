// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_tracker_dao.dart';

// ignore_for_file: type=lint
mixin _$HealthTrackerDaoMixin on DatabaseAccessor<KnightDatabase> {
  $HealthTrackerTableTable get healthTrackerTable =>
      attachedDatabase.healthTrackerTable;
  $BodyMeasurementTableTable get bodyMeasurementTable =>
      attachedDatabase.bodyMeasurementTable;
  HealthTrackerDaoManager get managers => HealthTrackerDaoManager(this);
}

class HealthTrackerDaoManager {
  final _$HealthTrackerDaoMixin _db;
  HealthTrackerDaoManager(this._db);
  $$HealthTrackerTableTableTableManager get healthTrackerTable =>
      $$HealthTrackerTableTableTableManager(
        _db.attachedDatabase,
        _db.healthTrackerTable,
      );
  $$BodyMeasurementTableTableTableManager get bodyMeasurementTable =>
      $$BodyMeasurementTableTableTableManager(
        _db.attachedDatabase,
        _db.bodyMeasurementTable,
      );
}
