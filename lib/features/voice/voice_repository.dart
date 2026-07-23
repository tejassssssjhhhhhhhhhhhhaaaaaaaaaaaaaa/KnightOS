import '../../core/storage/local_database.dart';
import '../../core/storage/storage_keys.dart';
import 'domain/voice_models.dart';

class VoiceRepository {
  VoiceRepository({LocalDatabase? localDatabase}) : _database = localDatabase ?? const LocalDatabase();

  final LocalDatabase _database;

  Future<List<VoiceMemory>> loadMemories() async {
    final decoded = await _database.readJsonList(StorageKeys.voiceMemories);
    if (decoded == null) {
      return const <VoiceMemory>[];
    }
    return decoded
        .whereType<Map<String, Object?>>()
        .map((item) => VoiceMemory.fromJson(item))
        .toList();
  }

  Future<void> saveMemory(VoiceMemory memory) async {
    final memories = await loadMemories();
    final updated = <VoiceMemory>[memory, ...memories.where((item) => item.id != memory.id)].toList();
    await _database.writeJsonList(StorageKeys.voiceMemories, updated.map((item) => item.toJson()).toList());
  }
}
