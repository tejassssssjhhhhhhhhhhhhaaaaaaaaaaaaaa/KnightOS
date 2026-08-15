import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knight_os/core/intelligence/knight_cognition.dart';
import 'package:knight_os/core/intelligence/providers/intelligence_providers.dart';
import 'package:knight_os/core/intelligence/providers/data_providers.dart';
import 'package:knight_os/core/intelligence/domain/cognitive_models.dart';
import 'package:knight_os/core/providers/database_provider.dart';
import 'package:knight_os/core/providers/mission_providers.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import 'package:knight_os/core/domain/entities/mission.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:drift/native.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:knight_os/core/providers/preferences_provider.dart';

class MockPathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async => '.';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  PathProviderPlatform.instance = MockPathProvider();

  group('Knight AI Category 2 Full Pipeline Tests', () {
    late ProviderContainer container;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      
      container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          knightDatabaseProvider.overrideWithValue(
            KnightDatabase.forTesting(NativeDatabase.memory()),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('Full Pipeline: Manual Mission -> AI Grounding', () async {
      final missionService = container.read(missionServiceProvider);
      final cognition = container.read(knightCognitionProvider);

      // 1. CAPTURE: Manual User Input
      await missionService.createMission(
        title: 'Complete Category 2 Validation',
        type: MissionType.task,
        owningDomain: 'system',
        priority: MissionPriority.high,
      );

      // 2. STORE/SSoT: Verify in DB
      final db = container.read(knightDatabaseProvider);
      final tasks = await db.missionDao.getAllTasks();
      expect(tasks.any((t) => t.title == 'Complete Category 2 Validation'), isTrue);

      // 3. KNIGHT AI: Query about tasks
      final result = await cognition.processRequest('What are my tasks?');

      // 4. RESPONSE: Verify grounding
      expect(result.response, contains('Complete Category 2 Validation'));
      expect(result.response, contains('[NAVIGATE:/planner]'));
    });

    test('Full Pipeline: Finance Data -> AI Analysis', () async {
      final db = container.read(knightDatabaseProvider);
      final cognition = container.read(knightCognitionProvider);

      // 1. CAPTURE: Simulated Finance Entry
      await db.financialDao.insertTransaction(TransactionTableCompanion.insert(
        id: 'tx-1',
        transactionId: 'tx-1',
        accountId: 'main-savings',
        merchant: 'STARBUCKS',
        institution: 'BANK',
        transactionDate: DateTime.now(),
        amount: 550.0,
        type: 'expense',
        category: 'Food',
        description: 'Morning Coffee',
        dedupeHash: 'coffee-1',
        originProviderId: const Value('test_manual'),
        confidenceScore: const Value(1.0),
        verificationState: const Value('OBSERVED'),
      ));

      // 2. KNIGHT AI: Query about spending
      final result = await cognition.processRequest('How much did I spend today?');

      // 3. RESPONSE: Verify data-driven answer
      expect(result.response, contains('550'));
      expect(result.response, contains('STARBUCKS'));
      expect(result.response, contains('[NAVIGATE:/finance]'));
    });

    test('Privacy: Unrelated query does not leak Finance data', () async {
      final db = container.read(knightDatabaseProvider);
      final cognition = container.read(knightCognitionProvider);

      // Ingest sensitive data
      await db.financialDao.insertTransaction(TransactionTableCompanion.insert(
        id: 'tx-sensitive',
        transactionId: 'tx-sensitive',
        accountId: 'main-savings',
        merchant: 'PRIVATE',
        institution: 'BANK',
        transactionDate: DateTime.now(),
        amount: 1000000.0,
        type: 'income',
        category: 'Salary',
        description: 'Large Deposit',
        dedupeHash: 'sensitive-1',
      ));

      // Query about something unrelated
      final result = await cognition.processRequest('How is the weather?');

      // Verify prompt construction (internal check via response if possible, 
      // or we can verify the trace evidence)
      expect(result.trace.evidence.where((e) => e.source == 'Finance Platform').isEmpty, isTrue);
      expect(result.response, isNot(contains('1000000')));
    });

    test('Usage Tracking Persistence', () async {
      final cognition = container.read(knightCognitionProvider);
      
      await cognition.processRequest('Test 1');
      await cognition.processRequest('Test 2');

      expect(container.read(aiUsageProvider), 2);
      
      // Verify persistence in prefs
      final prefs = container.read(sharedPreferencesProvider);
      expect(prefs.getInt('ai_usage_count'), 2);
    });
  });
}
