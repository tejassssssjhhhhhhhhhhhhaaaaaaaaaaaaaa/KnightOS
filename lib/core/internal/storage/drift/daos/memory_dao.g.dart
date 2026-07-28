// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_dao.dart';

// ignore_for_file: type=lint
mixin _$MemoryDaoMixin on DatabaseAccessor<KnightDatabase> {
  $MemoryTableTable get memoryTable => attachedDatabase.memoryTable;
  $MemoryRelationTableTable get memoryRelationTable =>
      attachedDatabase.memoryRelationTable;
  $EvidenceTableTable get evidenceTable => attachedDatabase.evidenceTable;
  $AttachmentTableTable get attachmentTable => attachedDatabase.attachmentTable;
  MemoryDaoManager get managers => MemoryDaoManager(this);
}

class MemoryDaoManager {
  final _$MemoryDaoMixin _db;
  MemoryDaoManager(this._db);
  $$MemoryTableTableTableManager get memoryTable =>
      $$MemoryTableTableTableManager(_db.attachedDatabase, _db.memoryTable);
  $$MemoryRelationTableTableTableManager get memoryRelationTable =>
      $$MemoryRelationTableTableTableManager(
        _db.attachedDatabase,
        _db.memoryRelationTable,
      );
  $$EvidenceTableTableTableManager get evidenceTable =>
      $$EvidenceTableTableTableManager(_db.attachedDatabase, _db.evidenceTable);
  $$AttachmentTableTableTableManager get attachmentTable =>
      $$AttachmentTableTableTableManager(
        _db.attachedDatabase,
        _db.attachmentTable,
      );
}
