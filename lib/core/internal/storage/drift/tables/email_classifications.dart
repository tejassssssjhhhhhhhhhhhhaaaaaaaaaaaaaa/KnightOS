import 'package:drift/drift.dart';
import '../knight_table.dart';
import 'gmail_messages.dart';

/// Stores classification results for emails.
@DataClassName('EmailClassification')
class EmailClassificationTable extends KnightTable {
  @override
  String get tableName => 'email_classifications';

  /// Reference to the Gmail message.
  TextColumn get messageId => text().references(GmailMessageTable, #id)();

  /// e.g. finance, travel, shopping, personal.
  TextColumn get category => text()();

  /// 0.0 to 1.0.
  RealColumn get confidenceScore => real().withDefault(const Constant(0.0))();

  /// Justification for the classification.
  TextColumn get confidenceReason => text().nullable()();

  /// Semantic version of the classifier engine.
  TextColumn get classifierVersion => text().withDefault(const Constant('1.0.0'))();

  /// unverified, likely, verified.
  TextColumn get verificationState => text().withDefault(const Constant('unverified'))();
}
