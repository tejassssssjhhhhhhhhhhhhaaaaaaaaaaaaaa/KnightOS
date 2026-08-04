import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:knight_os/features/finance/platform/sync/finance_report_service.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import 'package:knight_os/core/internal/storage/drift/daos/finance_platform_dao.dart';
import 'package:knight_os/features/finance/domain/finance_report_models.dart';

class MockKnightDatabase extends Mock implements KnightDatabase {}
class MockFinancePlatformDao extends Mock implements FinancePlatformDao {}

void main() {
  late FinanceReportService service;
  late MockKnightDatabase mockDb;
  late MockFinancePlatformDao mockDao;

  setUp(() {
    mockDb = MockKnightDatabase();
    mockDao = MockFinancePlatformDao();
    service = FinanceReportService(db: mockDb, dao: mockDao);
  });

  group('FinanceReportService', () {
    test('generateSummary aggregates data correctly', () async {
      final mockTxs = [
        TransactionData(
          id: '1',
          transactionId: 'tx1',
          transactionDate: DateTime(2024, 1, 1),
          amount: 1000.0,
          type: 'income',
          category: 'Salary',
          merchant: 'Employer',
          institution: 'Bank',
          description: 'Monthly pay',
          accountId: 'acc1',
          dedupeHash: 'hash1',
          verificationState: 'VERIFIED',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          version: 1,
          syncStatus: 'local',
          isDeleted: false,
          isLatest: true,
        ),
        TransactionData(
          id: '2',
          transactionId: 'tx2',
          transactionDate: DateTime(2024, 1, 5),
          amount: 200.0,
          type: 'expense',
          category: 'Food',
          merchant: 'UberEats',
          institution: 'Bank',
          description: 'Lunch',
          accountId: 'acc1',
          dedupeHash: 'hash2',
          verificationState: 'VERIFIED',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          version: 1,
          syncStatus: 'local',
          isDeleted: false,
          isLatest: true,
        ),
      ];

      when(() => mockDao.searchTransactions(
        start: any(named: 'start'),
        end: any(named: 'end'),
        categories: any(named: 'categories'),
      )).thenAnswer((_) async => mockTxs);

      final summary = await service.generateSummary(ReportType.monthly, ReportFilters());

      expect(summary.totalIncome, 1000.0);
      expect(summary.totalExpenses, 200.0);
      expect(summary.categoryBreakdown['Food'], 200.0);
      expect(summary.confidenceScore, 1.0);
      expect(summary.dataCoverage, contains('2 verified records'));
    });
  });
}
