import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/canonical_identities.dart';

part 'canonical_identity_dao.g.dart';

@DriftAccessor(tables: [CanonicalIdentityTable, IdentityAliasTable])
class CanonicalIdentityDao extends BaseDao<CanonicalIdentityTable, CanonicalIdentity>
    with _$CanonicalIdentityDaoMixin {
  CanonicalIdentityDao(super.db);

  Future<CanonicalIdentity?> getByName(String name) {
    return (select(canonicalIdentityTable)..where((t) => t.canonicalName.equals(name))).getSingleOrNull();
  }

  Future<CanonicalIdentity?> resolveFromAlias(String rawName) async {
    final alias = await (select(identityAliasTable)..where((t) => t.rawName.equals(rawName))).getSingleOrNull();
    if (alias == null) return null;
    return (select(canonicalIdentityTable)..where((t) => t.id.equals(alias.canonicalId))).getSingleOrNull();
  }

  Future<void> registerAlias(String rawName, String canonicalId) {
    return into(identityAliasTable).insertOnConflictUpdate(IdentityAliasTableCompanion.insert(
      id: 'alias-$rawName',
      rawName: rawName,
      canonicalId: canonicalId,
    ));
  }
}
