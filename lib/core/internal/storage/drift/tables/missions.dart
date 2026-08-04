import 'package:drift/drift.dart';
import '../knight_table.dart';

@DataClassName('MissionData')
class MissionTable extends KnightTable {
  @override
  String get tableName => 'missions';

  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get type => text()();
  TextColumn get owningDomain => text()();
  
  /// draft, active, paused, completed, cancelled, failed
  TextColumn get status => text().withDefault(const Constant('draft'))();
  
  /// critical, high, medium, low
  TextColumn get priority => text().withDefault(const Constant('medium'))();
  
  IntColumn get importance => integer().withDefault(const Constant(5))();
  IntColumn get urgency => integer().withDefault(const Constant(5))();
  
  DateTimeColumn get dueDate => dateTime().nullable()();
  RealColumn get progress => real().withDefault(const Constant(0.0))();
  RealColumn get alignmentScore => real().withDefault(const Constant(0.5))();
  
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get metadata => text().nullable()();

  // Note: For relational fields like relatedEvidenceIds, we'd use separate join tables.
  // For V1, we serialize them into metadata or use simplified columns.
}
