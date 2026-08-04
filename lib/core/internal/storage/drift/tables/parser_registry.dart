import 'package:drift/drift.dart';
import '../knight_table.dart';

/// Tracks extraction modules, their versions, and success rates.
@DataClassName('ParserMetadata')
class ParserRegistryTable extends KnightTable {
  @override
  String get tableName => 'parser_registry';

  /// Unique name (e.g., 'financial_statement_v4').
  TextColumn get parserId => text()();

  /// Semantic version (e.g. '1.0.2').
  TextColumn get parserVersion => text()();

  /// Target entity type (e.g., 'transaction', 'flight').
  TextColumn get targetType => text()();

  /// Total items processed.
  IntColumn get totalProcessed => integer().withDefault(const Constant(0))();

  /// Items successfully verified by user.
  IntColumn get verificationCount => integer().withDefault(const Constant(0))();

  /// Performance Metrics (M3 Requirement)
  RealColumn get accuracy => real().nullable()();
  IntColumn get falsePositives => integer().withDefault(const Constant(0))();
  IntColumn get falseNegatives => integer().withDefault(const Constant(0))();
  RealColumn get averageConfidence => real().nullable()();

  /// Last used timestamp.
  DateTimeColumn get lastUsed => dateTime()();
}
