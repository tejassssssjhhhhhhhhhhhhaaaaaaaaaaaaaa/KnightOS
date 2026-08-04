import 'package:drift/drift.dart';
import '../knight_table.dart';

/// Stores calculated trust and confidence scores for graph elements.
@DataClassName('TrustMetricData')
class TrustMetricsTable extends KnightTable {
  @override
  String get tableName => 'trust_metrics';

  /// Reference to the node or edge being measured
  TextColumn get targetId => text()();

  /// 0.0 (Unreliable) to 1.0 (Canonical Truth)
  RealColumn get score => real()();

  /// Probability that the extraction/linkage is correct
  RealColumn get confidence => real()();

  /// Version of the Trust Engine that calculated this score
  TextColumn get algorithmVersion => text()();

  /// Reasoning trace for the trust score
  TextColumn get calculationReason => text().nullable()();

  DateTimeColumn get lastCalculatedAt => dateTime().withDefault(currentDateAndTime)();
}
