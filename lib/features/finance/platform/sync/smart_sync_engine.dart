import 'dart:async';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';
import '../../../../core/internal/utils/knight_logger.dart';
import '../interfaces/finance_sync.dart';
import '../auth/gmail_connection_manager.dart';
import '../engine/finance_evidence_vault.dart';
import '../engine/repair_engine.dart';

class SmartSyncEngine implements ISmartSyncEngine {
  SmartSyncEngine({
    required this.db,
    required this.dao,
    required this.connectionManager,
    required this.vault,
    required this.repairEngine,
  });

  final KnightDatabase db;
  final FinancePlatformDao dao;
  final GmailConnectionManager connectionManager;
  final FinanceEvidenceVault vault;
  final RepairEngine repairEngine;

  final _progressController = StreamController<SyncProgress>.broadcast();

  @override
  Stream<SyncProgress> get progress => _progressController.stream;

  @override
  Future<void> startSync() async {
    final startTime = DateTime.now();
    _progressController.add(SyncProgress(percentage: 0.1, currentStage: 'Starting', status: 'Validating Connection...'));

    try {
      // 1. Validate Connection & Refresh Auth
      final isConnected = await connectionManager.isConnected();
      if (!isConnected) {
        await connectionManager.refreshConnection();
      }

      // 2. Process Discovered Messages (from centralized hub)
      _progressController.add(SyncProgress(percentage: 0.4, currentStage: 'Processing', status: 'Extracting financial data...'));
      final discovered = await dao.getJournalEntriesByResult('Discovered');
      for (final entry in discovered) {
        final msg = await (db.select(db.gmailMessageTable)..where((t) => t.id.equals(entry.messageId))).getSingleOrNull();
        if (msg != null) {
          await vault.ingestMessage(msg);
        }
      }

      // 3. Run Repair & Consistency Check
      _progressController.add(SyncProgress(percentage: 0.8, currentStage: 'Repairing', status: 'Verifying database consistency...'));
      await repairEngine.runFullRepair();

      // 4. Finalize & Report
      final endTime = DateTime.now();
      await dao.insertSyncHistory(FinanceSyncHistoryTableCompanion.insert(
        id: const Uuid().v4(),
        startTime: startTime,
        endTime: Value(endTime),
        overallResult: 'Success',
        syncReport: Value('Completed in ${endTime.difference(startTime).inSeconds}s'),
      ));

      _progressController.add(SyncProgress(percentage: 1.0, currentStage: 'Completed', status: 'Sync Finished.'));
    } catch (e) {
      KnightLogger.error('[FINANCE] Smart Sync Failed', error: e);
      await dao.insertSyncHistory(FinanceSyncHistoryTableCompanion.insert(
        id: const Uuid().v4(),
        startTime: startTime,
        endTime: Value(DateTime.now()),
        overallResult: 'Failed',
        errorLog: Value(e.toString()),
      ));
      _progressController.add(SyncProgress(percentage: 0.0, currentStage: 'Failed', status: 'Sync Error: ${e.toString()}'));
    }
  }

  @override
  Future<void> startHistoricalScan() async {
    // Finance no longer owns historical scan. It relies on Google Data Hub.
    KnightLogger.info('[FINANCE] Redirecting historical scan request to Google Data Hub');
  }

  @override
  Future<void> repair() async {
    await repairEngine.runFullRepair();
  }
}
