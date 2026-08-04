// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_dao.dart';

// ignore_for_file: type=lint
mixin _$ImportDaoMixin on DatabaseAccessor<KnightDatabase> {
  $ImportHistoryTableTable get importHistoryTable =>
      attachedDatabase.importHistoryTable;
  ImportDaoManager get managers => ImportDaoManager(this);
}

class ImportDaoManager {
  final _$ImportDaoMixin _db;
  ImportDaoManager(this._db);
  $$ImportHistoryTableTableTableManager get importHistoryTable =>
      $$ImportHistoryTableTableTableManager(
        _db.attachedDatabase,
        _db.importHistoryTable,
      );
}
