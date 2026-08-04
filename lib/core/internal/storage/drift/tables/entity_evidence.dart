import 'package:drift/drift.dart';
import '../knight_table.dart';
import 'extracted_entities.dart';

/// Audit trail for every extracted entity.
@DataClassName('EntityEvidence')
class EntityEvidenceTable extends KnightTable {
  @override
  String get tableName => 'entity_evidence';

  /// Reference to the entity.
  TextColumn get entityId => text().references(ExtractedEntityTable, #id)();

  TextColumn get originMessageId => text().nullable()();
  TextColumn get originThreadId => text().nullable()();
  TextColumn get originAccountId => text().nullable()();

  TextColumn get subject => text().nullable()();
  TextColumn get snippet => text().nullable()();
  TextColumn get bodySnippet => text().nullable()();

  /// The regex or heuristic rule that triggered extraction.
  TextColumn get matchedRule => text().nullable()();
  TextColumn get matchedPattern => text().nullable()();

  TextColumn get regexVersion => text().nullable()();
  TextColumn get parserVersion => text().nullable()();

  TextColumn get providerId => text().nullable()();
}
