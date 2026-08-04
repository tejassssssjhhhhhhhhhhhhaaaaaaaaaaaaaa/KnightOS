// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_dao.dart';

// ignore_for_file: type=lint
mixin _$HealthDaoMixin on DatabaseAccessor<KnightDatabase> {
  $ImportHistoryTableTable get importHistoryTable =>
      attachedDatabase.importHistoryTable;
  $HealthMetricTableTable get healthMetricTable =>
      attachedDatabase.healthMetricTable;
  HealthDaoManager get managers => HealthDaoManager(this);
}

class HealthDaoManager {
  final _$HealthDaoMixin _db;
  HealthDaoManager(this._db);
  $$ImportHistoryTableTableTableManager get importHistoryTable =>
      $$ImportHistoryTableTableTableManager(
        _db.attachedDatabase,
        _db.importHistoryTable,
      );
  $$HealthMetricTableTableTableManager get healthMetricTable =>
      $$HealthMetricTableTableTableManager(
        _db.attachedDatabase,
        _db.healthMetricTable,
      );
}
