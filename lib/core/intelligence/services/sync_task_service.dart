import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../internal/utils/knight_logger.dart';
import '../providers/intelligence_providers.dart';
import '../../providers/database_provider.dart';

enum WorkerState { idle, processing, waiting, failed }

class SyncTaskService extends Notifier<WorkerState> {
  Timer? _pollingTimer;
  bool _isProcessing = false;
  SyncTask? _currentTask;

  @override
  WorkerState build() => WorkerState.idle;

  SyncTask? get currentTask => _currentTask;

  void startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) => _processQueue());
    KnightLogger.info('[TASK] Sync task queue polling started', category: KnightLogCategory.worker);
    _scheduleProviderSyncs();
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    state = WorkerState.idle;
  }

  void _scheduleProviderSyncs() {
    final db = ref.read(knightDatabaseProvider);
    Timer.periodic(const Duration(minutes: 30), (_) async {
       await db.syncTaskDao.into(db.syncTaskQueueTable).insert(SyncTaskQueueTableCompanion.insert(
        id: 'sync-gmail-${DateTime.now().millisecondsSinceEpoch}',
        providerId: 'gmail_api',
        taskType: 'sync_provider',
        payload: '{}',
        priority: const Value(1),
        updatedAt: Value(DateTime.now()),
      ), mode: InsertMode.insertOrIgnore);
    });
  }

  Future<void> _processQueue() async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      final db = ref.read(knightDatabaseProvider);
      final tasks = await db.syncTaskDao.getPendingTasks(limit: 5);
      if (tasks.isEmpty) {
        _isProcessing = false;
        state = WorkerState.idle;
        return;
      }

      state = WorkerState.processing;
      for (final task in tasks) {
        _currentTask = task;
        await _executeTask(task);
      }
      _currentTask = null;
    } catch (e) {
      KnightLogger.error('[TASK] Queue processing error', error: e, category: KnightLogCategory.worker);
      state = WorkerState.failed;
    } finally {
      _isProcessing = false;
      if (state != WorkerState.failed) state = WorkerState.idle;
    }
  }

  Future<void> _executeTask(SyncTask task) async {
    final db = ref.read(knightDatabaseProvider);
    await db.syncTaskDao.updateTaskStatus(task.id, 'processing');
    
    try {
      final payload = jsonDecode(task.payload) as Map<String, dynamic>;

      switch (task.taskType) {
        case 'classify_email':
          final messageId = payload['messageId'] as String;
          final batchId = payload['batchId'] as String? ?? 'unknown';
          await ref.read(emailClassificationServiceProvider).classifyEmail(messageId);
          
          // CHAIN: After classification, queue extraction
          await db.syncTaskDao.into(db.syncTaskQueueTable).insert(SyncTaskQueueTableCompanion.insert(
            id: 'extract-$messageId',
            providerId: task.providerId,
            taskType: 'extract_entities',
            payload: jsonEncode({'messageId': messageId, 'batchId': batchId}),
            priority: const Value(4),
            updatedAt: Value(DateTime.now()),
          ), mode: InsertMode.insertOrIgnore);
          break;
          
        case 'extract_entities':
          final messageId = payload['messageId'] as String;
          final batchId = payload['batchId'] as String? ?? 'unknown';
          await ref.read(entityExtractionServiceProvider).extractEntitiesFromEmail(messageId, batchId);
          break;

        case 'sync_provider':
          final registry = ref.read(dataProviderRegistryProvider);
          final provider = registry.firstWhereOrNull((p) => p.id == task.providerId);
          if (provider != null) {
            await provider.syncIncremental();
          } else {
            throw Exception('Provider ${task.providerId} not found in registry');
          }
          break;
          
        default:
          throw Exception('Unknown task type: ${task.taskType}');
      }

      await db.syncTaskDao.updateTaskStatus(task.id, 'completed');
    } catch (e) {
      KnightLogger.error('[TASK] Task ${task.id} failed', error: e, category: KnightLogCategory.worker);
      final newRetryCount = task.retryCount + 1;
      final status = newRetryCount >= 3 ? 'failed' : 'pending';
      
      await db.syncTaskDao.updateTaskStatus(task.id, status, error: e.toString());
      await (db.update(db.syncTaskQueueTable)..where((t) => t.id.equals(task.id))).write(
        SyncTaskQueueTableCompanion(
          retryCount: Value(newRetryCount),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }
}

final syncTaskServiceProvider = NotifierProvider<SyncTaskService, WorkerState>(SyncTaskService.new);
