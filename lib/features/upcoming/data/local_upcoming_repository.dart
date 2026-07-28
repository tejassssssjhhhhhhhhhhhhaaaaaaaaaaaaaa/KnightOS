import '../../../core/storage/local_database.dart';
import '../../../core/storage/storage_keys.dart';
import '../domain/upcoming_item.dart';
import '../domain/upcoming_repository.dart';

class LocalUpcomingRepository implements UpcomingRepository {
  LocalUpcomingRepository({LocalDatabase? database})
    : _database = database ?? const LocalDatabase();

  final LocalDatabase _database;
  List<UpcomingItem>? _cache;

  @override
  Future<List<UpcomingItem>> getUpcomingItems() async {
    if (_cache != null) return _cache!;

    final data = await _database.readJsonList(StorageKeys.upcomingItems);
    if (data == null) {
      _cache = UpcomingItem.defaults;
      return _cache!;
    }

    try {
      _cache = data
          .map((e) => UpcomingItem.fromJson(e as Map<String, dynamic>))
          .toList();
      return _cache!;
    } catch (e) {
      _cache = UpcomingItem.defaults;
      return _cache!;
    }
  }

  @override
  Future<void> saveUpcomingItem(UpcomingItem item) async {
    final items = await getUpcomingItems();
    final index = items.indexWhere((e) => e.id == item.id);

    final updatedList = List<UpcomingItem>.from(items);
    if (index != -1) {
      updatedList[index] = item;
    } else {
      updatedList.add(item);
    }

    _cache = updatedList;
    await _saveToDisk(updatedList);
  }

  @override
  Future<void> deleteUpcomingItem(String id) async {
    final items = await getUpcomingItems();
    final updatedList = items.where((e) => e.id != id).toList();

    _cache = updatedList;
    await _saveToDisk(updatedList);
  }

  Future<void> _saveToDisk(List<UpcomingItem> items) async {
    await _database.writeJsonList(
      StorageKeys.upcomingItems,
      items.map((e) => e.toJson()).toList(),
    );
  }
}
