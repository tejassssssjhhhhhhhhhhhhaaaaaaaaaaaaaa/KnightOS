import '../../core/storage/local_database.dart';
import '../../core/storage/storage_keys.dart';
import 'memory_models.dart';

class MemoryRepository {
  MemoryRepository({LocalDatabase? localDatabase}) : _database = localDatabase ?? const LocalDatabase();

  final LocalDatabase _database;

  Future<List<MemoryItem>> loadMemories() async {
    final decoded = await _database.readJsonList(StorageKeys.voiceMemories);
    if (decoded == null) {
      return const <MemoryItem>[];
    }

    return decoded.whereType<Map<String, Object?>>().map((item) => MemoryItem.fromJson(item)).toList();
  }

  Future<void> saveMemory(MemoryItem memory) async {
    final memories = await loadMemories();
    final updated = <MemoryItem>[memory, ...memories.where((item) => item.id != memory.id)].toList();
    await _database.writeJsonList(StorageKeys.voiceMemories, updated.map((item) => item.toJson()).toList());
  }
}
