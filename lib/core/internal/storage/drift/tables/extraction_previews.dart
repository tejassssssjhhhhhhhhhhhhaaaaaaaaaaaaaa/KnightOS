import 'package:drift/drift.dart';
import '../knight_table.dart';

/// Buffer for pending extractions awaiting validation.
@DataClassName('ExtractionPreview')
class ExtractionPreviewTable extends KnightTable {
  @override
  String get tableName => 'extraction_previews';

  TextColumn get messageId => text()();
  
  /// JSON payload of detected fields.
  TextColumn get detectedData => text()();
  
  TextColumn get category => text()();
  RealColumn get confidence => real()();
  
  TextColumn get evidenceType => text()();
  
  /// unverified, pending_review.
  TextColumn get status => text().withDefault(const Constant('unverified'))();

  @override
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
