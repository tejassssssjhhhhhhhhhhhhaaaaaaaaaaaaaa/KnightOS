import 'package:drift/drift.dart';
import '../knight_table.dart';

/// Tracks files imported into the system for traceability and duplicate detection.
@DataClassName('ImportHistoryData')
class ImportHistoryTable extends KnightTable {
  @override
  String get tableName => 'import_history';

  /// Original file name.
  TextColumn get fileName => text()();

  /// Absolute path at time of import.
  TextColumn get filePath => text()();

  /// Detected document type (e.g., bank_statement, location_history).
  TextColumn get docType => text()();

  /// Version of the parser used for this import.
  IntColumn get parserVersion => integer().withDefault(const Constant(1))();

  /// Number of records extracted.
  IntColumn get recordCount => integer().withDefault(const Constant(0))();

  /// Success, failed, partial.
  TextColumn get status => text().withDefault(const Constant('success'))();

  /// Error message if failed.
  TextColumn get errorMessage => text().nullable()();
}
