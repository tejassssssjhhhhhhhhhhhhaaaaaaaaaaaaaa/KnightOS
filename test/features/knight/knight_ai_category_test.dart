import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knight_os/core/intelligence/knight_cognition.dart';
import 'package:knight_os/core/intelligence/providers/intelligence_providers.dart';
import 'package:knight_os/core/intelligence/domain/cognitive_models.dart';
import 'package:knight_os/core/providers/database_provider.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import 'package:drift/native.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  PathProviderPlatform.instance = MockPathProvider();

  group('Knight AI Category 2 Integration Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          knightDatabaseProvider.overrideWithValue(
            KnightDatabase.forTesting(NativeDatabase.memory()),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('Cognitive Pipeline - Intent Detection & Augmented Prompt', () async {
      final cognition = container.read(knightCognitionProvider);

      const query = 'How much did I spend?';
      final result = await cognition.processRequest(query);

      expect(result.trace.intent, KnightIntent.analysis);
      // Response for empty context
      expect(result.response, contains('Data Hub is connected'));
    });

    test('Cognitive Pipeline - Teleport Intent', () async {
      final cognition = container.read(knightCognitionProvider);

      const query = 'Open my health dashboard';
      final result = await cognition.processRequest(query);

      expect(result.response, contains('[NAVIGATE:/health]'));
    });

    test('Neural Core Usage Increment', () async {
      final cognition = container.read(knightCognitionProvider);
      
      final initialUsage = container.read(aiUsageProvider);
      
      await cognition.processRequest('Hello');
      
      final newUsage = container.read(aiUsageProvider);
      expect(newUsage, initialUsage + 1);
    });
   group('Data Hub Grounding', () {
    test('Verified Evidence is passed to prompt', () async {
      // Future: Add data to in-memory DB and verify response contains it
    });
  });
  });
}
