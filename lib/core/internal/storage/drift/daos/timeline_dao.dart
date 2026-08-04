import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/timeline_events.dart';

part 'timeline_dao.g.dart';

@DriftAccessor(tables: [TimelineEventTable])
class TimelineDao extends DatabaseAccessor<KnightDatabase> with _$TimelineDaoMixin {
  TimelineDao(super.db);

  Future<List<TimelineEventData>> getEventsInRange(DateTime start, DateTime end) {
    return (select(timelineEventTable)
          ..where((t) => t.startTime.isBetweenValues(start, end))
          ..orderBy([(t) => OrderingTerm.asc(t.startTime)]))
        .get();
  }

  Future<void> insertEvents(List<TimelineEventTableCompanion> events) async {
    await batch((batch) {
      batch.insertAll(timelineEventTable, events, mode: InsertMode.insertOrReplace);
    });
  }

  Future<void> deleteEventsFromSource(String sourceImportId) async {
    await (delete(timelineEventTable)..where((t) => t.sourceImportId.equals(sourceImportId))).go();
  }

  Future<List<TimelineEventData>> getRecentEvents({int limit = 10}) {
    return (select(timelineEventTable)
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)])
          ..limit(limit))
        .get();
  }

  Future<void> deleteById(String id) async {
    await (delete(timelineEventTable)..where((t) => t.id.equals(id))).go();
  }
}
