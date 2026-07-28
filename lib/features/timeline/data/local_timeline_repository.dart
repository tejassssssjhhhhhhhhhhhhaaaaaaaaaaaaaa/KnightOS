import '../../../core/storage/local_database.dart';
import '../../../core/storage/storage_keys.dart';
import '../domain/timeline_entry.dart';
import '../domain/timeline_repository.dart';

class LocalTimelineRepository implements TimelineRepository {
  LocalTimelineRepository({LocalDatabase? database})
    : _database = database ?? const LocalDatabase();

  final LocalDatabase _database;
  List<TimelineEntry>? _cache;

  @override
  Future<List<TimelineEntry>> getEntries() async {
    if (_cache != null) return _cache!;

    final data = await _database.readJsonList(StorageKeys.timelineEntries);
    if (data == null) {
      _cache = TimelineEntry.defaults;
      return _cache!;
    }

    try {
      _cache = data
          .map((e) => TimelineEntry.fromJson(e as Map<String, dynamic>))
          .toList();
      _cache!.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return _cache!;
    } catch (e) {
      _cache = TimelineEntry.defaults;
      return _cache!;
    }
  }

  @override
  Future<void> saveEntry(TimelineEntry entry) async {
    final entries = await getEntries();
    final index = entries.indexWhere((e) => e.id == entry.id);

    final updatedList = List<TimelineEntry>.from(entries);
    if (index != -1) {
      updatedList[index] = entry;
    } else {
      updatedList.add(entry);
    }

    _cache = updatedList;
    await _saveToDisk(updatedList);
  }

  @override
  Future<void> deleteEntry(String id) async {
    final entries = await getEntries();
    final updatedList = entries.where((e) => e.id != id).toList();

    _cache = updatedList;
    await _saveToDisk(updatedList);
  }

  Future<void> _saveToDisk(List<TimelineEntry> entries) async {
    await _database.writeJsonList(
      StorageKeys.timelineEntries,
      entries.map((e) => e.toJson()).toList(),
    );
  }
}
