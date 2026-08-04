import 'package:drift/drift.dart';
import '../knight_table.dart';

/// Performance and accuracy tracking for the extraction engine.
@DataClassName('ExtractionAnalytic')
class ExtractionAnalyticsTable extends KnightTable {
  @override
  String get tableName => 'extraction_analytics';

  TextColumn get batchId => text()();
  
  IntColumn get entitiesExtracted => integer()();
  IntColumn get extractionTimeMs => integer()();
  
  RealColumn get averageConfidence => real()();
  
  IntColumn get validationFailures => integer().withDefault(const Constant(0))();
  IntColumn get duplicateEntities => integer().withDefault(const Constant(0))();
  IntColumn get canonicalMatches => integer().withDefault(const Constant(0))();

  @override
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
