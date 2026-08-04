import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/runtime_events.dart';

part 'runtime_recorder_dao.g.dart';

@DriftAccessor(tables: [RuntimeEventsTable])
class RuntimeRecorderDao extends BaseDao<RuntimeEventsTable, RuntimeEvent>
    with _$RuntimeRecorderDaoMixin {
  RuntimeRecorderDao(super.db);

  Future<void> logEvent(RuntimeEventsTableCompanion companion) {
    return into(runtimeEventsTable).insert(companion);
  }

  Future<List<RuntimeEvent>> getRecentEvents({int limit = 100}) {
    return (select(runtimeEventsTable)
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)])
          ..limit(limit))
        .get();
  }
}
