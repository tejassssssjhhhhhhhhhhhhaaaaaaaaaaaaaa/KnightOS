import '../../core/storage/local_database.dart';
import '../../core/storage/storage_keys.dart';
import 'learning_models.dart';

class LearningRepository {
  LearningRepository({LocalDatabase? localDatabase})
    : _database = localDatabase ?? const LocalDatabase();

  final LocalDatabase _database;

  Future<List<LearningGoal>> loadGoals() async {
    final decoded = await _database.readJsonList(StorageKeys.voiceMemories);
    if (decoded == null) {
      return const <LearningGoal>[];
    }

    return decoded
        .whereType<Map<String, Object?>>()
        .map((item) => LearningGoal.fromJson(item))
        .toList();
  }

  Future<void> saveGoal(LearningGoal goal) async {
    final goals = await loadGoals();
    final updated = <LearningGoal>[
      goal,
      ...goals.where((item) => item.id != goal.id),
    ].toList();
    await _database.writeJsonList(
      StorageKeys.voiceMemories,
      updated.map((item) => item.toJson()).toList(),
    );
  }
}
