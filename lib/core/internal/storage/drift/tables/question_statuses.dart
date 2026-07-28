import 'package:drift/drift.dart';
import '../knight_table.dart';

/// Tracks the progress of the Discovery Engine for every inquiry.
class QuestionStatusTable extends KnightTable {
  @override
  String get tableName => 'question_statuses';

  /// The unique ID from the Question Bank (e.g. B01-Q001).
  TextColumn get questionId => text()();

  /// Whether the user has provided a valid answer.
  BoolColumn get isAnswered => boolean().withDefault(const Constant(false))();

  /// Whether the user has explicitly skipped this question.
  BoolColumn get isSkipped => boolean().withDefault(const Constant(false))();

  /// When the question was last presented to the user.
  DateTimeColumn get lastOffered => dateTime().nullable()();

  /// Link to the generated memory ID if answered.
  TextColumn get memoryId => text().nullable()();
}
