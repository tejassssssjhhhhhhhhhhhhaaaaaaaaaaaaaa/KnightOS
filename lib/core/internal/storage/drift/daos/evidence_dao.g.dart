// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evidence_dao.dart';

// ignore_for_file: type=lint
mixin _$EvidenceDaoMixin on DatabaseAccessor<KnightDatabase> {
  $EvidenceTableTable get evidenceTable => attachedDatabase.evidenceTable;
  EvidenceDaoManager get managers => EvidenceDaoManager(this);
}

class EvidenceDaoManager {
  final _$EvidenceDaoMixin _db;
  EvidenceDaoManager(this._db);
  $$EvidenceTableTableTableManager get evidenceTable =>
      $$EvidenceTableTableTableManager(_db.attachedDatabase, _db.evidenceTable);
}
