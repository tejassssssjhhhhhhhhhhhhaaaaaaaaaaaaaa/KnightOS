// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extracted_entity_dao.dart';

// ignore_for_file: type=lint
mixin _$ExtractedEntityDaoMixin on DatabaseAccessor<KnightDatabase> {
  $CanonicalIdentityTableTable get canonicalIdentityTable =>
      attachedDatabase.canonicalIdentityTable;
  $ExtractedEntityTableTable get extractedEntityTable =>
      attachedDatabase.extractedEntityTable;
  ExtractedEntityDaoManager get managers => ExtractedEntityDaoManager(this);
}

class ExtractedEntityDaoManager {
  final _$ExtractedEntityDaoMixin _db;
  ExtractedEntityDaoManager(this._db);
  $$CanonicalIdentityTableTableTableManager get canonicalIdentityTable =>
      $$CanonicalIdentityTableTableTableManager(
        _db.attachedDatabase,
        _db.canonicalIdentityTable,
      );
  $$ExtractedEntityTableTableTableManager get extractedEntityTable =>
      $$ExtractedEntityTableTableTableManager(
        _db.attachedDatabase,
        _db.extractedEntityTable,
      );
}
