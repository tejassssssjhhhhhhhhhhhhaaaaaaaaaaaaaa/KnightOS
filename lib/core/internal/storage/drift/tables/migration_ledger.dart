import 'package:drift/drift.dart';
import '../knight_table.dart';

/// Internal System Table: Data Migration Ledger
class MigrationLedger extends KnightTable {
  TextColumn get module => text()();
  IntColumn get migratedRecords => integer()();
  IntColumn get failedRecords => integer()();
  TextColumn get status => text()(); // success, failed, partial
}
