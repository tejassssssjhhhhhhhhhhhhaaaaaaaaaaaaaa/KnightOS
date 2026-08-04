import 'package:drift/drift.dart';
import '../knight_table.dart';
import 'gmail_messages.dart';

@DataClassName('FinanceExtractionData')
class FinanceExtractionTable extends KnightTable {
  @override
  String get tableName => 'finance_extractions';

  TextColumn get messageId => text().references(GmailMessageTable, #id)();
  TextColumn get parserVersion => text()();
  
  // High Precision Fields (Raw)
  RealColumn get amount => real().nullable()();
  TextColumn get currency => text().nullable()();
  TextColumn get merchant => text().nullable()();
  TextColumn get referenceNumber => text().nullable()();
  TextColumn get account => text().nullable()();
  TextColumn get card => text().nullable()();
  RealColumn get balance => real().nullable()();
  TextColumn get statementPeriod => text().nullable()();
  TextColumn get paymentMethod => text().nullable()();
  TextColumn get institution => text().nullable()();
  
  // Extraction Metadata
  TextColumn get confidenceLevel => text()(); // High, Medium, Low
  RealColumn get confidenceScore => real()();
  TextColumn get rawExtractedData => text().nullable()(); // JSON blob of all fields
  
  DateTimeColumn get extractionTimestamp => dateTime().withDefault(currentDateAndTime)();
}
