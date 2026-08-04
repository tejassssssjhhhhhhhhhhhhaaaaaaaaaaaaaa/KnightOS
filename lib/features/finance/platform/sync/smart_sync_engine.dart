import 'dart:async';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';
import '../../../../core/internal/utils/knight_logger.dart';
import '../interfaces/finance_sync.dart';
import '../auth/gmail_connection_manager.dart';
import '../engine/finance_evidence_vault.dart';
import '../engine/repair_engine.dart';
import 'historical_scanner_service.dart';

class SmartSyncEngine implements ISmartSyncEngine {
  SmartSyncEngine({
    required this.db,
    required this.dao,
    required this.connectionManager,
    required this.scanner,
    required this.vault,
    required this.repairEngine,
  });

  final KnightDatabase db;
  final FinancePlatformDao dao;
  final GmailConnectionManager connectionManager;
  final HistoricalScannerService scanner;
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

      // 2. Fetch New Messages (Historical Scan with Cursor)
      _progressController.add(SyncProgress(percentage: 0.3, currentStage: 'Scanning', status: 'Fetching latest emails...'));
      await scanner.startHistoricalScan();

      // 3. Process Discovered Messages
      _progressController.add(SyncProgress(percentage: 0.6, currentStage: 'Processing', status: 'Extracting financial data...'));
      final discovered = await dao.getJournalEntriesByResult('Discovered');
      for (final entry in discovered) {
        final msg = await (db.select(db.gmailMessageTable)..where((t) => t.id.equals(entry.messageId))).getSingleOrNull();
        if (msg != null) {
          await vault.ingestMessage(msg);
        }
      }

      // 4. Run Repair & Consistency Check
      _progressController.add(SyncProgress(percentage: 0.8, currentStage: 'Repairing', status: 'Verifying database consistency...'));
      await repairEngine.runFullRepair();

      // 5. Finalize & Report
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
    await scanner.startHistoricalScan();
  }

  @override
  Future<void> repair() async {
    await repairEngine.runFullRepair();
  }
}
