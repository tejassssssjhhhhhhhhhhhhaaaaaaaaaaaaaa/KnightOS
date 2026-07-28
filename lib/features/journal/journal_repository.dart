import '../../core/storage/local_database.dart';
import '../../core/storage/storage_keys.dart';
import 'journal_models.dart';

class JournalRepository {
  JournalRepository({LocalDatabase? localDatabase})
    : _database = localDatabase ?? const LocalDatabase();

  final LocalDatabase _database;

  Future<List<JournalEntry>> loadEntries() async {
    final decoded = await _database.readJsonList(StorageKeys.voiceMemories);
    if (decoded == null) {
      return const <JournalEntry>[];
    }

    return decoded
        .whereType<Map<String, Object?>>()
        .map((item) => JournalEntry.fromJson(item))
        .toList();
  }

  Future<void> saveEntry(JournalEntry entry) async {
    final entries = await loadEntries();
    final updated = <JournalEntry>[
      entry,
      ...entries.where((item) => item.id != entry.id),
    ].toList();
    await _database.writeJsonList(
      StorageKeys.voiceMemories,
      updated.map((item) => item.toJson()).toList(),
    );
  }
}
