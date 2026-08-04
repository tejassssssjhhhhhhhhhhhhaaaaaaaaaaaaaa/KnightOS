import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/sync_task_queue.dart';

part 'sync_task_dao.g.dart';

@DriftAccessor(tables: [SyncTaskQueueTable])
class SyncTaskDao extends BaseDao<SyncTaskQueueTable, SyncTask>
    with _$SyncTaskDaoMixin {
  SyncTaskDao(super.db);

  Future<List<SyncTask>> getPendingTasks({int limit = 10}) {
    return (select(syncTaskQueueTable)
          ..where((t) => t.status.equals('pending'))
          ..orderBy([(t) => OrderingTerm(expression: t.priority, mode: OrderingMode.asc)])
          ..limit(limit))
        .get();
  }

  Future<void> updateTaskStatus(String id, String status, {String? error}) {
    return (update(syncTaskQueueTable)..where((t) => t.id.equals(id))).write(
      SyncTaskQueueTableCompanion(
        status: Value(status),
        lastError: Value(error),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
