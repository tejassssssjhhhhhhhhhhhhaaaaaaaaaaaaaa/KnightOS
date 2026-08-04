import 'package:drift/drift.dart';
import '../knight_table.dart';

/// Stores raw metadata for Gmail messages before extraction.
@DataClassName('GmailMessageData')
class GmailMessageTable extends KnightTable {
  @override
  String get tableName => 'gmail_messages';

  @override
  TextColumn get id => text()(); // messageId

  TextColumn get threadId => text()();
  TextColumn get historyId => text()();
  TextColumn get subject => text()();
  TextColumn get sender => text()();
  TextColumn get recipients => text()();
  DateTimeColumn get messageDate => dateTime()();
  
  /// JSON list of labels.
  TextColumn get labels => text()();
  
  TextColumn get snippet => text()();
  
  /// raw Int64 from Gmail.
  Int64Column get internalDate => int64()();
  
  /// JSON metadata for attachments.
  TextColumn get attachmentMetadata => text().nullable()();
  
  /// Local path or URI to body if saved.
  TextColumn get bodyReference => text().nullable()();
  
  TextColumn get originAccount => text()();
  
  /// JSON blob of raw API response.
  TextColumn get rawMetadata => text().nullable()();
}
