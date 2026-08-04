import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/extracted_entities.dart';

part 'extracted_entity_dao.g.dart';

@DriftAccessor(tables: [ExtractedEntityTable])
class ExtractedEntityDao extends BaseDao<ExtractedEntityTable, ExtractedEntity>
    with _$ExtractedEntityDaoMixin {
  ExtractedEntityDao(super.db);

  Future<void> upsertEntity(ExtractedEntityTableCompanion companion) {
    return into(extractedEntityTable).insertOnConflictUpdate(companion);
  }

  Future<List<ExtractedEntity>> getAllEntities() => select(extractedEntityTable).get();
}
