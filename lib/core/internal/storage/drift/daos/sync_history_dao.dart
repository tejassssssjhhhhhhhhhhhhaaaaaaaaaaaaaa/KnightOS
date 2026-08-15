import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/sync_history.dart';
import '../../../../intelligence/domain/data_provider.dart';

part 'sync_history_dao.g.dart';

@DriftAccessor(tables: [SyncHistoryTable])
class SyncHistoryDao extends DatabaseAccessor<KnightDatabase> with _$SyncHistoryDaoMixin {
  SyncHistoryDao(super.db);

  Future<int> insertRecord(SyncHistoryTableCompanion companion) {
    return into(syncHistoryTable).insert(companion);
  }

  Future<void> updateRecord(SyncHistoryTableCompanion companion) {
    return (update(syncHistoryTable)..where((t) => t.id.equals(companion.id.value))).write(companion);
  }

  Future<List<SyncHistoryData>> getRecent(String providerId, {int limit = 10}) {
    return (select(syncHistoryTable)
          ..where((t) => t.providerId.equals(providerId))
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)])
          ..limit(limit))
        .get();
  }

  Future<SyncHistoryData?> getLastSuccessful(String providerId) {
    return (select(syncHistoryTable)
          ..where((t) => t.providerId.equals(providerId))
          ..where((t) => t.status.equals('success'))
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<SyncHistoryData?> getById(String id) {
    return (select(syncHistoryTable)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<SyncStats> getAggregatedStats(String providerId) async {
    final history = await (select(syncHistoryTable)..where((t) => t.providerId.equals(providerId))).get();
    int f = 0, c = 0, u = 0, s = 0, fa = 0;
    for (final h in history) {
      f += h.fetchedCount.toInt();
      c += h.createdCount.toInt();
      u += h.updatedCount.toInt();
      s += h.skippedCount.toInt();
      fa += h.failedCount.toInt();
    }
    return SyncStats(
      fetched: f,
      created: c,
      updated: u,
      skipped: s,
      failed: fa,
    );
  }

  Future<int> deleteOldRecords(DateTime before) {
    return (delete(syncHistoryTable)..where((t) => t.startTime.isSmallerThanValue(before))).go();
  }
}
