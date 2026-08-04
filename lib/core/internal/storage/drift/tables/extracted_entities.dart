import 'package:drift/drift.dart';
import '../knight_table.dart';
import 'canonical_identities.dart';

/// Central storage for all extracted knowledge entities.
@DataClassName('ExtractedEntity')
class ExtractedEntityTable extends KnightTable {
  @override
  String get tableName => 'extracted_entities';

  /// e.g. transaction, booking, order, bill.
  TextColumn get entityType => text()();

  /// e.g. upi, flight, amazon_order.
  TextColumn get entitySubtype => text()();

  /// Reference to normalized identity (e.g. AMAZON).
  TextColumn get canonicalId => text().nullable().references(CanonicalIdentityTable, #id)();

  /// Human-readable title.
  TextColumn get title => text()();

  /// Short summary of the entity.
  TextColumn get summary => text().nullable()();

  /// Logical timestamp of the event.
  DateTimeColumn get eventTimestamp => dateTime()();

  /// When the source was received.
  DateTimeColumn get receivedTimestamp => dateTime()();

  /// Name of the parser used.
  TextColumn get parserName => text()();

  /// Version of the parser used.
  TextColumn get parserVersion => text()();

  /// 0.0 to 1.0.
  RealColumn get confidenceScore => real().withDefault(const Constant(0.0))();

  /// Reasoning for the score.
  TextColumn get confidenceReason => text().nullable()();

  /// unverified, likely, verified, user_confirmed, user_corrected, system_revalidated.
  TextColumn get verificationState => text().withDefault(const Constant('unverified'))();

  /// Whether the user has manually corrected this.
  BoolColumn get userCorrected => boolean().withDefault(const Constant(false))();

  /// Batch ID for the extraction run.
  TextColumn get syncBatchId => text().nullable()();

  /// Incremental entity version.
  @override
  IntColumn get version => integer().withDefault(const Constant(1))();

  /// Reference to the evidence.
  TextColumn get evidenceId => text().nullable()();

  /// When the extraction was performed.
  DateTimeColumn get extractionTimestamp => dateTime().withDefault(currentDateAndTime)();
}
