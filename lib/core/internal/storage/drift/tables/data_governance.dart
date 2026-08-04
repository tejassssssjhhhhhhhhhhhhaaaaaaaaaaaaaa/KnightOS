import 'package:drift/drift.dart';
import '../knight_table.dart';

/// Defines privacy and lifecycle rules for graph data.
@DataClassName('DataGovernanceData')
class DataGovernanceTable extends KnightTable {
  @override
  String get tableName => 'data_governance';

  TextColumn get entityId => text().unique()();

  /// public, private, sensitive, secret
  TextColumn get classification => text().withDefault(const Constant('private'))();

  /// Retention in days (null = permanent)
  IntColumn get retentionDays => integer().nullable()();

  BoolColumn get isExportable => boolean().withDefault(const Constant(true))();

  BoolColumn get isAITrainingAllowed => boolean().withDefault(const Constant(false))();

  DateTimeColumn get lastAuditedAt => dateTime().nullable()();

  /// Legal or Compliance flags (GDPR, HIPAA, etc.)
  TextColumn get complianceFlags => text().nullable()();
}
