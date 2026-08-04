import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../internal/utils/knight_logger.dart';
import '../../providers/database_provider.dart';

class SnapshotService {
  SnapshotService({required this.db});
  final KnightDatabase db;

  Future<void> capture(String trigger) async {
    try {
      final state = await _gatherSystemState();
      await db.snapshotDao.createSnapshot(SystemSnapshotsTableCompanion.insert(
        id: const Uuid().v4(),
        trigger: trigger,
        stateData: jsonEncode(state),
        createdAt: Value(DateTime.now()),
      ));
      KnightLogger.info('[TIME MACHINE] Captured snapshot triggered by: $trigger', category: KnightLogCategory.database);
    } catch (e) {
      KnightLogger.error('[TIME MACHINE] Failed to capture snapshot', error: e, category: KnightLogCategory.database);
    }
  }

  Future<Map<String, dynamic>> _gatherSystemState() async {
    final emails = await db.customSelect('SELECT COUNT(*) as c FROM gmail_messages').getSingle();
    final entities = await db.customSelect('SELECT COUNT(*) as c FROM extracted_entities').getSingle();
    final queue = await db.customSelect('SELECT COUNT(*) as c FROM sync_task_queue WHERE status = "pending"').getSingle();
    
    return {
      'db_version': 13,
      'email_count': emails.read<int>('c'),
      'entity_count': entities.read<int>('c'),
      'pending_tasks': queue.read<int>('c'),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  Future<List<SystemSnapshot>> getHistory() => db.snapshotDao.getHistory();
}

final snapshotServiceProvider = Provider<SnapshotService>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  return SnapshotService(db: db);
});
