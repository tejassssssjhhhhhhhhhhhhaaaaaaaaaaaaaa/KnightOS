// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_dao.dart';

// ignore_for_file: type=lint
mixin _$MedicationDaoMixin on DatabaseAccessor<KnightDatabase> {
  $MedicationTableTable get medicationTable => attachedDatabase.medicationTable;
  $MedicationLogTableTable get medicationLogTable =>
      attachedDatabase.medicationLogTable;
  MedicationDaoManager get managers => MedicationDaoManager(this);
}

class MedicationDaoManager {
  final _$MedicationDaoMixin _db;
  MedicationDaoManager(this._db);
  $$MedicationTableTableTableManager get medicationTable =>
      $$MedicationTableTableTableManager(
        _db.attachedDatabase,
        _db.medicationTable,
      );
  $$MedicationLogTableTableTableManager get medicationLogTable =>
      $$MedicationLogTableTableTableManager(
        _db.attachedDatabase,
        _db.medicationLogTable,
      );
}
