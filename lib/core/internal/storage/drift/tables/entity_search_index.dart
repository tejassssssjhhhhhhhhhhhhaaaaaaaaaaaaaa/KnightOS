import 'package:drift/drift.dart';
import '../knight_table.dart';
import 'extracted_entities.dart';

/// Flat search index for performant entity lookups.
@DataClassName('EntitySearchRecord')
class EntitySearchIndexTable extends KnightTable {
  @override
  String get tableName => 'entity_search_index';

  TextColumn get entityId => text().references(ExtractedEntityTable, #id)();

  /// Keywords for search (Merchant, PNR, OrderID, etc).
  TextColumn get searchToken => text()();

  /// Type of token (e.g. merchant, pnr, city).
  TextColumn get tokenType => text()();

  /// Weight for ranking (0.0 - 1.0).
  RealColumn get weight => real().withDefault(const Constant(1.0))();

  @override
  Set<Column> get primaryKey => {entityId, searchToken, tokenType};
}
