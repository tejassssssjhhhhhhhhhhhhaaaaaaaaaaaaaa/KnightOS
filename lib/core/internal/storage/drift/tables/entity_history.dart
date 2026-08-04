import 'package:drift/drift.dart';
import '../knight_table.dart';
import 'extracted_entities.dart';

/// Revision history for entities to prevent overwriting.
@DataClassName('EntityHistoryRecord')
class EntityHistoryTable extends KnightTable {
  @override
  String get tableName => 'entity_history';

  TextColumn get entityId => text().references(ExtractedEntityTable, #id)();

  IntColumn get entityVersion => integer()();

  /// JSON blob of the entity state at this version.
  TextColumn get entityData => text()();

  /// reason for the change (user_correction, parser_improvement).
  TextColumn get changeReason => text()();

  @override
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {entityId, entityVersion};
}
