import 'package:drift/drift.dart';
import '../knight_table.dart';

/// Stores security policies, encryption salts, and audit state.
@DataClassName('SecurityMetadata')
class SecurityMetadataTable extends KnightTable {
  @override
  String get tableName => 'security_metadata';

  TextColumn get key => text()();
  TextColumn get value => text()();

  /// low, medium, high, military.
  TextColumn get securityLevel => text().withDefault(const Constant('high'))();

  /// If this value is encrypted with the user's master key.
  BoolColumn get isEncrypted => boolean().withDefault(const Constant(false))();

  @override
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {key};
}
