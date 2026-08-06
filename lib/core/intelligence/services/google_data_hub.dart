import 'dart:async';
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
import 'travel_history_orchestrator.dart';
import 'google_health_provider.dart';
import 'samsung_health_provider.dart';

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

  GoogleHealthProvider get _healthProvider => GoogleHealthProvider(ingestionService: ref.read(dataIngestionServiceProvider));
  SamsungHealthProvider get _samsungHealthProvider => SamsungHealthProvider(ingestionService: ref.read(dataIngestionServiceProvider), db: _db);

  final _progressController = StreamController<HubProgress>.broadcast();
  Stream<HubProgress> get progress => _progressController.stream;

  @override
  HubStatus build() {
    return HubStatus.disconnected;
  }

  Future<void> startUnifiedSync() async {
    if (state == HubStatus.syncingHistorical || state == HubStatus.syncingIncremental) return;

    try {
      if (_auth.currentUser == null) {
        final silentUser = await _auth.signInSilently();
        if (silentUser == null) {
          state = HubStatus.disconnected;
          return;
        }
      }
      
      state = HubStatus.connected;
      
      final lastSync = await _gmailOrchestrator.getCursor('last_history_id');
      if (lastSync == null) {
        await runHistoricalImport();
      } else {
        await runIncrementalSync();
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

    try {
      // 1. Gmail Loop
      final now = DateTime.now();
      int startYear = int.tryParse(await _gmailOrchestrator.getCursor('historical_import_year') ?? '2015') ?? 2015;
      int startMonth = int.tryParse(await _gmailOrchestrator.getCursor('historical_import_month') ?? '1') ?? 1;

      for (int year = startYear; year <= now.year; year++) {
        int endMonth = (year == now.year) ? now.month : 12;
        for (int month = (year == startYear ? startMonth : 1); month <= endMonth; month++) {
          await _gmailOrchestrator.updateCursor('historical_import_year', year.toString());
          await _gmailOrchestrator.updateCursor('historical_import_month', month.toString());
          await _gmailOrchestrator.syncMonth(year, month);
          
          // Yield to main thread to keep UI responsive during long loops
          await Future.delayed(const Duration(milliseconds: 100));
        }
      }
      await _gmailOrchestrator.anchorToPresent();

      // 2. Calendar
      await _calendarOrchestrator.executeSync();

      // 3. Contacts
      await _contactsOrchestrator.executeSync();

      // 4. Drive
      await _driveOrchestrator.executeSync();

      // 5. Tasks
      await _tasksOrchestrator.executeSync();

      // 6. Health
      try {
        await _healthProvider.connect();
        await _healthProvider.syncIncremental();
        await _samsungHealthProvider.connect();
        await _samsungHealthProvider.syncIncremental();
      } catch (e) {
        KnightLogger.warn('[HUB] Health sync skipped or failed: $e');
      }

      // 7. Post-Process Travel
      final travelOrch = TravelHistoryOrchestrator(db: _db);
      await travelOrch.reconstructTravelHistory();

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
    final emails = await _db.gmailMessageDao.select(_db.gmailMessageTable).get();
    final resources = await _db.googleResourceDao.select(_db.googleResourceTable).get();
    final transactions = await _db.financePlatformDao.select(_db.transactionTable).get();
    final healthMetrics = await _db.select(_db.healthMetricTable).get();

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
      status: state.name.toUpperCase(),
    ));
  }

  Future<void> runIncrementalSync() async {
    state = HubStatus.syncingIncremental;
    try {
      await Future.wait([
        _gmailOrchestrator.executeSync(),
        _calendarOrchestrator.executeSync(),
        _driveOrchestrator.executeSync(),
        _tasksOrchestrator.executeSync(),
        _healthProvider.syncIncremental(),
        _samsungHealthProvider.syncIncremental(),
      ]);
      state = HubStatus.connected;
    } catch (e) {
      state = HubStatus.error;
    }
  }
}

final googleDataHubProvider = NotifierProvider<GoogleDataHub, HubStatus>(GoogleDataHub.new);
