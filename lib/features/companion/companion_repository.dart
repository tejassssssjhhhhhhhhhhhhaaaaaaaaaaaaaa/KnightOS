import '../../core/storage/local_database.dart';
import '../../core/storage/storage_keys.dart';
import 'companion_models.dart';

class CompanionRepository {
  CompanionRepository({LocalDatabase? localDatabase}) : _database = localDatabase ?? const LocalDatabase();

  final LocalDatabase _database;

  Future<List<CompanionEntry>> loadEntries() async {
    final decoded = await _database.readJsonList(StorageKeys.voiceMemories);
    if (decoded == null) {
      return const <CompanionEntry>[];
    }

    return decoded
        .whereType<Map<String, Object?>>()
        .map((item) => CompanionEntry.fromJson(item))
        .toList();
  }

  Future<void> saveEntry(CompanionEntry entry) async {
    final entries = await loadEntries();
    final updated = <CompanionEntry>[entry, ...entries.where((item) => item.id != entry.id)].toList();
    await _database.writeJsonList(StorageKeys.voiceMemories, updated.map((item) => item.toJson()).toList());
  }
}
