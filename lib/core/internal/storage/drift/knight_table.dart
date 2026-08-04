import 'package:drift/drift.dart';

/// Flagship Base Table for Knight OS.
/// All internal tables should inherit from this to ensure metadata consistency.
abstract class KnightTable extends Table {
  TextColumn get id => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get version => integer().withDefault(const Constant(1))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  
  /// pending, synced, error, local_only
  TextColumn get syncStatus => text().withDefault(const Constant('local_only'))();
  
  /// cloud_provider, onedrive_local, health_connect, etc.
  TextColumn get sourceProvider => text().nullable()();
  
  /// The unique ID from the source provider (e.g., file path, API ID).
  TextColumn get sourceIdentifier => text().nullable()();
  
  /// hash of the content for duplicate detection.
  TextColumn get contentHash => text().nullable()();
  
  TextColumn get deviceId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
