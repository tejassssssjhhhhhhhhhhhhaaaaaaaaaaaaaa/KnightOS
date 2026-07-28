import '../../../core/storage/local_database.dart';
import '../../../core/storage/storage_keys.dart';
import '../domain/focus_area.dart';
import '../domain/focus_repository.dart';

/// Persistence-backed implementation of [FocusRepository] using [LocalDatabase].
class LocalFocusRepository implements FocusRepository {
  LocalFocusRepository({LocalDatabase? database})
    : _database = database ?? const LocalDatabase();

  final LocalDatabase _database;
  List<FocusArea>? _cache;

  @override
  Future<List<FocusArea>> getFocusAreas() async {
    if (_cache != null) return _cache!;

    final data = await _database.readJsonList(StorageKeys.focusAreas);
    if (data == null) {
      _cache = FocusArea.placeholders;
      return _cache!;
    }

    try {
      _cache = data
          .map((e) => FocusArea.fromJson(e as Map<String, dynamic>))
          .toList();
      return _cache!;
    } catch (e) {
      // Fallback to placeholders if data is corrupt
      _cache = FocusArea.placeholders;
      return _cache!;
    }
  }

  @override
  Future<void> updateFocusArea(FocusArea area) async {
    final areas = await getFocusAreas();
    final index = areas.indexWhere((e) => e.category == area.category);

    final updatedList = List<FocusArea>.from(areas);
    if (index != -1) {
      updatedList[index] = area;
    } else {
      updatedList.add(area);
    }

    _cache = updatedList;
    await _database.writeJsonList(
      StorageKeys.focusAreas,
      updatedList.map((e) => e.toJson()).toList(),
    );
  }
}
