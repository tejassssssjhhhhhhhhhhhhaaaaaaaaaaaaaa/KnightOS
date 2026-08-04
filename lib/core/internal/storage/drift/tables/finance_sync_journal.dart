import 'package:drift/drift.dart';
import '../knight_table.dart';

@DataClassName('FinanceSyncJournalData')
class FinanceSyncJournalTable extends KnightTable {
  @override
  String get tableName => 'finance_sync_journal';

  TextColumn get messageId => text()();
  TextColumn get parserVersion => text()();
  
  /// Terminal States: Parsed, Needs Review, Unsupported, Non-Financial
  TextColumn get processingResult => text()();
  
  DateTimeColumn get processedAt => dateTime()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get errorLog => text().nullable()();
  
  /// Track if this message has been merged as a duplicate
  BoolColumn get isDuplicate => boolean().withDefault(const Constant(false))();
  TextColumn get mergedIntoTransactionId => text().nullable()();
}
