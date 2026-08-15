import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../internal/utils/knight_logger.dart';
import 'package:knight_os/core/providers/storage_providers.dart';
import 'package:knight_os/core/providers/database_provider.dart';
import 'package:knight_os/core/providers/preferences_provider.dart';
import 'package:knight_os/core/providers/relaxation_mode_provider.dart';
import 'package:knight_os/core/intelligence/providers/intelligence_providers.dart';
import 'travel_history_orchestrator.dart';

enum WorkerState { idle, processing, waiting, failed }

class SyncTaskService extends Notifier<WorkerState> {
  Timer? _pollingTimer;
  Timer? _scheduleTimer;
  bool _isProcessing = false;
  SyncTask? _currentTask;

  @override
  WorkerState build() => WorkerState.idle;

  SyncTask? get currentTask => _currentTask;

  void startPolling() {
    _pollingTimer?.cancel();
    // P0: Reduce polling frequency to avoid database lock contention and main thread lag
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) => _processQueue());
    KnightLogger.info('[TASK] Sync task queue polling started', category: KnightLogCategory.worker);
    refreshSchedule();
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _scheduleTimer?.cancel();
    state = WorkerState.idle;
  }

  void refreshSchedule() {
    _scheduleTimer?.cancel();
    final prefs = ref.read(importPreferenceServiceProvider);
    if (!prefs.isAutoSyncEnabled()) {
      KnightLogger.info('[TASK] Auto-sync disabled by user.');
      return;
    }

    final freq = prefs.getSyncFrequency();
    Duration interval;
    switch (freq) {
      case 'hourly': interval = const Duration(hours: 1); break;
      case 'daily': interval = const Duration(days: 1); break;
      case 'weekly': interval = const Duration(days: 7); break;
      default: interval = const Duration(days: 1);
    }
    
    KnightLogger.info('[TASK] Scheduling provider syncs every $freq ($interval)');
    _scheduleTimer = Timer.periodic(interval, (_) => _queueProviderSyncs());
    
    // Initial trigger check could go here
  }

  Future<void> _queueProviderSyncs() async {
    final db = ref.read(knightDatabaseProvider);
    final registry = ref.read(dataProviderRegistryProvider);
    final providers = ['gmail_api', 'google_calendar_api', 'google_drive_api', 'google_contacts_api', 'google_tasks_api'];
    for (final p in providers) {
      final provider = registry.firstWhereOrNull((dp) => dp.id == p);
      if (provider == null || !provider.isEnabled) continue;

      await db.syncTaskDao.into(db.syncTaskQueueTable).insert(SyncTaskQueueTableCompanion.insert(
        id: 'sync-$p-${DateTime.now().millisecondsSinceEpoch}',
        providerId: p,
        taskType: 'sync_provider',
        payload: '{}',
        priority: const Value(1),
        updatedAt: Value(DateTime.now()),
      ), mode: InsertMode.insertOrIgnore);
    }
  }

  Future<void> runFullQueue() async {
     await _processQueue();
  }

  Future<void> _processQueue() async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      final db = ref.read(knightDatabaseProvider);
      
      // 1. Run Maintenance (Sprint 1.2 Cleanup)
      await _runMaintenance(db);

      // 2. Process smaller batches to maintain UI responsiveness
      final tasks = await db.syncTaskDao.getPendingTasks(limit: 10);
      if (tasks.isEmpty) {
        _isProcessing = false;
        state = WorkerState.idle;
        return;
      }

      state = WorkerState.processing;
      for (final task in tasks) {
        _currentTask = task;
        await _executeTask(task);
        // Yield after every task
        await Future.delayed(const Duration(milliseconds: 50));
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

  Future<void> _runMaintenance(KnightDatabase db) async {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    
    // Cleanup old sync history
    final deletedHistory = await db.syncHistoryDao.deleteOldRecords(sevenDaysAgo);
    
    // Cleanup completed/failed tasks older than 7 days
    final deletedTasks = await db.syncTaskDao.cleanupCompletedTasks(sevenDaysAgo);

    if (deletedHistory > 0 || deletedTasks > 0) {
      KnightLogger.info('[TASK] Maintenance: Deleted $deletedHistory history records and $deletedTasks old tasks.');
    }
  }

  Future<void> _executeTask(SyncTask task) async {
    final db = ref.read(knightDatabaseProvider);
    await db.syncTaskDao.updateTaskStatus(task.id, 'processing');
    
    KnightLogger.info('[TASK] Executing task: ${task.id} Type: ${task.taskType}');

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

        case 'reconstruct_travel':
          final travelOrch = TravelHistoryOrchestrator(db: db);
          await travelOrch.reconstructTravelHistory();
          break;

        case 'sync_provider':
          final registry = ref.read(dataProviderRegistryProvider);
          final provider = registry.firstWhereOrNull((p) => p.id == task.providerId);
          if (provider != null) {
            if (provider.isEnabled) {
              await provider.syncIncremental();
            } else {
              KnightLogger.info('[TASK] Skipping sync for disabled provider: ${task.providerId}');
            }
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
