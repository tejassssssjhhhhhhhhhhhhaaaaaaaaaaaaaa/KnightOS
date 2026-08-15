import 'dart:async';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knight_os/core/providers/database_provider.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../services/google_auth_service.dart';
import '../../internal/utils/knight_logger.dart';
import '../providers/data_providers.dart';
import 'gmail_sync_orchestrator.dart';
import 'calendar_sync_orchestrator.dart';
import 'contacts_sync_orchestrator.dart';
import 'drive_sync_orchestrator.dart';
import 'tasks_sync_orchestrator.dart';
import 'google_health_provider.dart';
import 'samsung_health_provider.dart';
import 'import_preference_service.dart';
import '../providers/intelligence_providers.dart';
import '../../providers/storage_providers.dart';
import '../../internal/utils/db_auditor.dart';

enum HubStatus { disconnected, connected, syncingHistorical, syncingIncremental, error }

class HubProgress {
  final int currentYear;
  final int currentMonth;
  final int emailsImported;
  final int calendarEvents;
  final int contacts;
  final int driveFiles;
  final int tasks;
  final int transactions;
  final int healthRecords;
  final int totalProcessed;
  final int fetchedCount;
  final int parsedCount;
  final int normalizedCount;
  final int persistedCount;
  final String currentSource;
  final String status;

  HubProgress({
    this.currentYear = 0,
    this.currentMonth = 0,
    this.emailsImported = 0,
    this.calendarEvents = 0,
    this.contacts = 0,
    this.driveFiles = 0,
    this.tasks = 0,
    this.transactions = 0,
    this.healthRecords = 0,
    this.totalProcessed = 0,
    this.fetchedCount = 0,
    this.parsedCount = 0,
    this.normalizedCount = 0,
    this.persistedCount = 0,
    this.currentSource = 'Idle',
    this.status = 'Idle',
  });
}

class GoogleDataHub extends Notifier<HubStatus> {
  KnightDatabase get _db => ref.read(knightDatabaseProvider);
  GoogleAuthService get _auth => GoogleAuthService.instance;
  
  GmailSyncOrchestrator get _gmailOrchestrator => GmailSyncOrchestrator(db: _db, authService: _auth);
  CalendarSyncOrchestrator get _calendarOrchestrator => CalendarSyncOrchestrator(db: _db, authService: _auth);
  ContactsSyncOrchestrator get _contactsOrchestrator => ContactsSyncOrchestrator(db: _db, authService: _auth);
  DriveSyncOrchestrator get _driveOrchestrator => DriveSyncOrchestrator(db: _db, authService: _auth);
  TasksSyncOrchestrator get _tasksOrchestrator => TasksSyncOrchestrator(db: _db, authService: _auth);

  final _progressController = StreamController<HubProgress>.broadcast();
  Stream<HubProgress> get progress => _progressController.stream;

  @override
  HubStatus build() {
    return HubStatus.disconnected;
  }

  Future<void> startUnifiedSync() async {
    if (state == HubStatus.syncingHistorical || state == HubStatus.syncingIncremental) return;

    KnightLogger.info('[HUB] Starting Unified Sync sequence');

    try {
      if (_auth.currentUser == null) {
        KnightLogger.info('[HUB] No user detected, attempting silent sign-in');
        final silentUser = await _auth.signInSilently();
        if (silentUser == null) {
          KnightLogger.warn('[HUB] Silent sign-in failed. Disconnecting.');
          state = HubStatus.disconnected;
          return;
        }
      }
      
      KnightLogger.info('[HUB] Authentication verified: ${_auth.currentUser?.email}');
      state = HubStatus.connected;
      
      final lastSync = await _gmailOrchestrator.getCursor('last_history_id');
      if (lastSync == null) {
        await runHistoricalImport();
      } else {
        await ref.read(dataProviderRegistryProvider.notifier).syncAll();
        state = HubStatus.connected;
      }
    } catch (e) {
      state = HubStatus.error;
      KnightLogger.error('[HUB] Unified sync failed', error: e);
    }
  }

  Future<void> runHistoricalImport() async {
    state = HubStatus.syncingHistorical;
    KnightLogger.info('[HUB] Starting Exhaustive Historical Import');

    final statsTimer = Timer.periodic(const Duration(seconds: 3), (_) => refreshStats());
    final prefs = ref.read(importPreferenceServiceProvider);

    try {
      // 1. Gmail Exhaustive
      await _gmailOrchestrator.runSync();

      // 2. Calendar
      await _calendarOrchestrator.runSync();

      // 3. Contacts
      await _contactsOrchestrator.runSync();

      // 4. Drive
      await _driveOrchestrator.runSync();

      // 5. Tasks
      await _tasksOrchestrator.runSync();

      // 6. Health
      try {
        final registry = ref.read(dataProviderRegistryProvider);
        final gh = registry.firstWhereOrNull((p) => p.id == 'google_health_provider');
        if (gh != null) await gh.syncIncremental();
        
        final sh = registry.firstWhereOrNull((p) => p.id == 'samsung_health_provider');
        if (sh != null) await sh.syncIncremental();
      } catch (e) {
        KnightLogger.warn('[HUB] Health sync skipped or failed: $e');
      }

      // 7. Post-Process Travel (Queued to run after extractions)
      await _db.syncTaskDao.into(_db.syncTaskQueueTable).insert(SyncTaskQueueTableCompanion.insert(
        id: 'travel-reconstruct-${DateTime.now().millisecondsSinceEpoch}',
        providerId: 'system',
        taskType: 'reconstruct_travel',
        payload: '{}',
        priority: const Value(5), // Lowest priority, run last
        updatedAt: Value(DateTime.now()),
      ), mode: InsertMode.insertOrIgnore);

      state = HubStatus.connected;
      KnightLogger.info('[HUB] All historical sources imported successfully.');
    } catch (e) {
      state = HubStatus.error;
      KnightLogger.error('[HUB] Historical import aborted', error: e);
    } finally {
      statsTimer.cancel();
      await refreshStats();
    }
  }

  Future<void> refreshStats() async {
    await DbAuditor.logCounts(_db);
    final emails = await _db.gmailMessageDao.select(_db.gmailMessageTable).get();
    final resources = await _db.googleResourceDao.select(_db.googleResourceTable).get();
    final transactions = await _db.financePlatformDao.select(_db.transactionTable).get();
    final healthMetrics = await _db.select(_db.healthMetricTable).get();
    
    // Pipeline Observability from SyncHistory
    final allHistory = await (_db.select(_db.syncHistoryTable)).get();
    final fetched = allHistory.fold<int>(0, (sum, h) => sum + h.fetchedCount);
    final parsed = allHistory.fold<int>(0, (sum, h) => sum + h.createdCount + h.updatedCount);
    final persisted = allHistory.fold<int>(0, (sum, h) => sum + h.createdCount);

    final year = await _gmailOrchestrator.getCursor('historical_import_year') ?? '---';
    final month = await _gmailOrchestrator.getCursor('historical_import_month') ?? '---';

    _progressController.add(HubProgress(
      currentYear: int.tryParse(year) ?? 0,
      currentMonth: int.tryParse(month) ?? 0,
      emailsImported: emails.length,
      calendarEvents: resources.where((r) => r.resourceType == 'calendar').length,
      contacts: resources.where((r) => r.resourceType == 'contact').length,
      driveFiles: resources.where((r) => r.resourceType == 'drive').length,
      tasks: resources.where((r) => r.resourceType == 'task').length,
      transactions: transactions.length,
      healthRecords: healthMetrics.length,
      totalProcessed: emails.length + resources.length + healthMetrics.length,
      fetchedCount: fetched,
      parsedCount: parsed,
      normalizedCount: parsed,
      persistedCount: persisted,
      status: state.name.toUpperCase(),
    ));
  }

  Future<void> runIncrementalSync() async {
    state = HubStatus.syncingIncremental;
    try {
      await ref.read(dataProviderRegistryProvider.notifier).syncAll();
      state = HubStatus.connected;
    } catch (e) {
      state = HubStatus.error;
    }
  }
}

final googleDataHubProvider = NotifierProvider<GoogleDataHub, HubStatus>(GoogleDataHub.new);
