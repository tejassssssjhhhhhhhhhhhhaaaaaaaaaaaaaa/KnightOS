import '../../core/storage/local_database.dart';

class BackupRepository {
  BackupRepository({LocalDatabase? localDatabase})
    : _database = localDatabase ?? const LocalDatabase();

  final LocalDatabase _database;

  Future<void> backupSnapshot(Map<String, Object?> snapshot) async {
    await _database.writeJson(
      'backup_snapshot.json',
      snapshot.cast<String, dynamic>(),
    );
  }

  Future<Map<String, Object?>?> loadSnapshot() async {
    final decoded = await _database.readJson('backup_snapshot.json');
    if (decoded == null) {
      return null;
    }
    return decoded;
  }
}
