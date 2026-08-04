import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:knight_os/features/finance/platform/sync/finance_advisor_service.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import 'package:knight_os/core/internal/storage/drift/daos/finance_platform_dao.dart';
import 'package:knight_os/features/finance/domain/finance_advisor_models.dart';

class MockKnightDatabase extends Mock implements KnightDatabase {}
class MockFinancePlatformDao extends Mock implements FinancePlatformDao {}

void main() {
  late FinanceAdvisorService service;
  late MockKnightDatabase mockDb;
  late MockFinancePlatformDao mockDao;

  setUp(() {
    mockDb = MockKnightDatabase();
    mockDao = MockFinancePlatformDao();
    service = FinanceAdvisorService(db: mockDb, dao: mockDao);
  });

  group('FinanceAdvisorService', () {
    test('Process Amazon query returns correct response', () async {
      when(() => mockDao.searchTransactions(
        query: any(named: 'query'),
        start: any(named: 'start'),
        end: any(named: 'end'),
      )).thenAnswer((_) async => []);

      final response = await service.processQuery('How much did I spend on Amazon in 2024?');

      expect(response.answer, contains('You spent ₹0.00 on Amazon in 2024'));
      expect(response.confidence, 0.99);
      expect(response.evidence, contains('Evidence Vault'));
    });

    test('Process Fuel query uses category filter', () async {
      when(() => mockDao.searchTransactions(
        categories: any(named: 'categories'),
        start: any(named: 'start'),
        end: any(named: 'end'),
      )).thenAnswer((_) async => []);

      final response = await service.processQuery('Show fuel spending for 2024');

      expect(response.answer, contains('Your Fuel spending in 2024 was ₹0.00'));
      verify(() => mockDao.searchTransactions(
        categories: ['Fuel'],
        start: any(named: 'start'),
        end: any(named: 'end'),
      )).called(1);
    });

    test('Process Income query uses type filter', () async {
      when(() => mockDao.searchTransactions(
        types: any(named: 'types'),
        limit: any(named: 'limit'),
      )).thenAnswer((_) async => []);

      final response = await service.processQuery('Show my salary history');

      expect(response.answer, contains('latest recorded income was ₹0.00'));
      verify(() => mockDao.searchTransactions(
        types: ['income'],
        limit: 12,
      )).called(1);
    });
  });
}
