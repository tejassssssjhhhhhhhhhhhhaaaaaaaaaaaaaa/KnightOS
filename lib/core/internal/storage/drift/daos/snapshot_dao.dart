import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/system_snapshots.dart';

part 'snapshot_dao.g.dart';

@DriftAccessor(tables: [SystemSnapshotsTable])
class SnapshotDao extends BaseDao<SystemSnapshotsTable, SystemSnapshot>
    with _$SnapshotDaoMixin {
  SnapshotDao(super.db);

  Future<void> createSnapshot(SystemSnapshotsTableCompanion companion) {
    return into(systemSnapshotsTable).insert(companion);
  }

  Future<List<SystemSnapshot>> getHistory() {
    return (select(systemSnapshotsTable)
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
        .get();
  }
}
