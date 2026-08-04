import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/import_history.dart';

part 'import_dao.g.dart';

@DriftAccessor(tables: [ImportHistoryTable])
class ImportDao extends BaseDao<ImportHistoryTable, ImportHistoryData> with _$ImportDaoMixin {
  ImportDao(super.db);

  Future<ImportHistoryData?> getByHash(String hash) {
    return (select(importHistoryTable)..where((t) => t.contentHash.equals(hash)))
        .getSingleOrNull();
  }

  Future<List<ImportHistoryData>> getAllImports() {
    return (select(importHistoryTable)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
  }
}
