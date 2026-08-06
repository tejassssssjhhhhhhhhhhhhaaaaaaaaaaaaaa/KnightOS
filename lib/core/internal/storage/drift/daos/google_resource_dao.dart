import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/google_resources.dart';

part 'google_resource_dao.g.dart';

@DriftAccessor(tables: [GoogleResourceTable])
class GoogleResourceDao extends DatabaseAccessor<KnightDatabase> with _$GoogleResourceDaoMixin {
  GoogleResourceDao(super.db);

  Future<void> upsertResource(GoogleResourceTableCompanion companion) {
    return into(googleResourceTable).insertOnConflictUpdate(companion);
  }

  Future<GoogleResourceData?> getById(String id) {
    return (select(googleResourceTable)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<GoogleResourceData>> getByType(String type) {
    return (select(googleResourceTable)..where((t) => t.resourceType.equals(type))).get();
  }
}
