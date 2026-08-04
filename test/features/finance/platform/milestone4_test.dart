import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_test/flutter_test.dart' hide isNotNull, isNull;
import 'package:knight_os/features/finance/platform/engine/finance_health_center.dart';
import 'package:knight_os/features/finance/platform/engine/repair_engine.dart';
import 'package:knight_os/features/finance/platform/sync/smart_sync_engine.dart';
import 'package:knight_os/features/finance/platform/auth/gmail_connection_manager.dart';
import 'package:knight_os/features/finance/platform/sync/historical_scanner_service.dart';
import 'package:knight_os/features/finance/platform/engine/finance_evidence_vault.dart';
import 'package:knight_os/features/finance/platform/interfaces/finance_health.dart';

class MockGmailConnectionManager extends Mock implements GmailConnectionManager {}
class MockHistoricalScannerService extends Mock implements HistoricalScannerService {}
class MockFinanceEvidenceVault extends Mock implements FinanceEvidenceVault {}

void main() {
  late KnightDatabase db;
  late FinancePlatformDao dao;
  late FinanceHealthCenter healthCenter;
  late RepairEngine repairEngine;
  late SmartSyncEngine smartSync;
  
  late MockGmailConnectionManager mockConn;
  late MockHistoricalScannerService mockScanner;
  late MockFinanceEvidenceVault mockVault;

  setUp(() {
    db = KnightDatabase.forTesting(NativeDatabase.memory());
    dao = FinancePlatformDao(db);
    mockConn = MockGmailConnectionManager();
    mockScanner = MockHistoricalScannerService();
    mockVault = MockFinanceEvidenceVault();

    healthCenter = FinanceHealthCenter(db: db, connectionManager: mockConn, dao: dao);
    repairEngine = RepairEngine(db: db, dao: dao, vault: mockVault);
    smartSync = SmartSyncEngine(
      db: db,
      dao: dao,
      connectionManager: mockConn,
      scanner: mockScanner,
      vault: mockVault,
      repairEngine: repairEngine,
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('FinanceHealthCenter', () {
    test('reports actionRequired when disconnected', () async {
      when(() => mockConn.isConnected()).thenAnswer((_) async => false);
      
      final status = await healthCenter.getOverallStatus();
      expect(status, FinanceHealthStatus.actionRequired);
    });

    test('calculates health score correctly', () async {
      when(() => mockConn.isConnected()).thenAnswer((_) async => true);
      // No tasks, no unsupported -> 100
      final score = await healthCenter.calculateHealthScore();
      expect(score, 100);
    });
   group('RepairEngine', () {
    test('repairs missing sync journal entries', () async {
      await db.into(db.gmailMessageTable).insert(
        GmailMessageTableCompanion.insert(
          id: 'msg1',
          threadId: 't1',
          historyId: 'h1',
          subject: 'S1',
          sender: 'S1',
          recipients: 'R1',
          messageDate: DateTime.now(),
          labels: '',
          snippet: 'S1',
          internalDate: BigInt.from(0),
          originAccount: 'me',
        ),
      );

      final entryBefore = await dao.getJournalEntry('msg1');
      expect(entryBefore, isNull);

      await repairEngine.runFullRepair();

      final entryAfter = await dao.getJournalEntry('msg1');
      expect(entryAfter, isNotNull);
      expect(entryAfter!.processingResult, 'Discovered');
    });
  });

  group('SmartSyncEngine', () {
    test('executes full pipeline and logs history', () async {
      when(() => mockConn.isConnected()).thenAnswer((_) async => true);
      when(() => mockScanner.startHistoricalScan()).thenAnswer((_) async {});
      
      await smartSync.startSync();

      final history = await dao.getLastSyncHistory();
      expect(history, isNotNull);
      expect(history!.overallResult, 'Success');
    });
  });
  });
}
