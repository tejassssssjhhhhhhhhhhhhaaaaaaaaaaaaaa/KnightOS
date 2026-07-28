import 'timeline_entry.dart';

abstract class TimelineRepository {
  Future<List<TimelineEntry>> getEntries();
  Future<void> saveEntry(TimelineEntry entry);
  Future<void> deleteEntry(String id);
}
