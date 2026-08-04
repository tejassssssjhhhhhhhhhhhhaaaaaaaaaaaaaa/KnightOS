import 'package:drift/drift.dart';
import '../knight_table.dart';

/// Schema for data retention and privacy policies per entity or category.
@DataClassName('DataPrivacyMetadata')
class DataPrivacyMetadataTable extends KnightTable {
  @override
  String get tableName => 'data_privacy_metadata';

  /// Target entity ID or Category Name.
  TextColumn get targetId => text()();

  /// active, archived, deleted.
  TextColumn get retentionPolicy => text().withDefault(const Constant('active'))();

  /// public, private, restricted, sensitive.
  TextColumn get visibility => text().withDefault(const Constant('private'))();

  /// low, medium, high.
  TextColumn get sensitivityLevel => text().withDefault(const Constant('medium'))();

  /// boolean flag for deletion.
  BoolColumn get deletionStatus => boolean().withDefault(const Constant(false))();

  /// Scope of user consent (JSON list).
  TextColumn get userConsentScope => text().nullable()();

  @override
  Set<Column> get primaryKey => {targetId};
}
