// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'canonical_identity_dao.dart';

// ignore_for_file: type=lint
mixin _$CanonicalIdentityDaoMixin on DatabaseAccessor<KnightDatabase> {
  $CanonicalIdentityTableTable get canonicalIdentityTable =>
      attachedDatabase.canonicalIdentityTable;
  $IdentityAliasTableTable get identityAliasTable =>
      attachedDatabase.identityAliasTable;
  CanonicalIdentityDaoManager get managers => CanonicalIdentityDaoManager(this);
}

class CanonicalIdentityDaoManager {
  final _$CanonicalIdentityDaoMixin _db;
  CanonicalIdentityDaoManager(this._db);
  $$CanonicalIdentityTableTableTableManager get canonicalIdentityTable =>
      $$CanonicalIdentityTableTableTableManager(
        _db.attachedDatabase,
        _db.canonicalIdentityTable,
      );
  $$IdentityAliasTableTableTableManager get identityAliasTable =>
      $$IdentityAliasTableTableTableManager(
        _db.attachedDatabase,
        _db.identityAliasTable,
      );
}
