import 'package:drift/drift.dart';
import '../knight_table.dart';

/// Immutable record of all state changes within the Knowledge Base.
@DataClassName('AuditLogData')
class AuditLogTable extends KnightTable {
  @override
  String get tableName => 'audit_logs';

  /// When the change occurred.
  DateTimeColumn get timestamp => dateTime()();

  /// INSERT, UPDATE, DELETE, DEDUP.
  TextColumn get operation => text()();

  /// The affected table.
  TextColumn get tableNameRef => text()();

  /// Primary key of the affected record.
  TextColumn get recordId => text()();

  /// JSON details of the change or reasoning.
  TextColumn get details => text().nullable()();
}
