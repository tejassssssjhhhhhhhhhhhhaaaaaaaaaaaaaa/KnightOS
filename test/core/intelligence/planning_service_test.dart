import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/domain/cognitive_models.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';
import 'package:knight_os/core/intelligence/domain/repositories/memory_repository.dart';
import 'package:knight_os/core/intelligence/engines/memory_engine.dart';
import 'package:knight_os/core/intelligence/engines/planning_engine.dart';
import 'package:knight_os/core/intelligence/engines/reasoning_engine.dart';
import 'package:knight_os/core/intelligence/knight_context_service.dart';
import 'package:knight_os/core/intelligence/services/json_validation_service.dart';
import 'package:knight_os/core/intelligence/services/memory_service.dart';
import 'package:knight_os/core/intelligence/services/planning_service.dart';
import 'package:knight_os/core/intelligence/services/reasoning_service.dart';

class MockMemoryRepository extends Fake implements MemoryRepository {
  @override
  Future<List<KnightMemory>> search(String query) async => [];
}

class MockJsonValidationService extends Fake implements JsonValidationService {
  @override
  Future<void> validate(MemoryDomain domain, Map<String, dynamic> content) async {}
}

void main() {
  late PlanningService service;
  late PlanningEngine engine;
  late MemoryEngine memoryEngine;
  late KnightContextService contextService;
  late ReasoningService reasoningService;

  setUp(() {
    engine = const PlanningEngine();
    memoryEngine = MemoryEngine(
      repository: MockMemoryRepository(),
      validationService: MockJsonValidationService(),
    );
    contextService = KnightContextService();
    reasoningService = ReasoningService(
      engine: const ReasoningEngine(),
      memoryEngine: memoryEngine,
      contextService: contextService,
    );
    service = PlanningService(
      engine: engine,
      memoryEngine: memoryEngine,
      contextService: contextService,
      reasoningService: reasoningService,
    );
  });

  group('PlanningService', () {
    test('generateDailyPlan coordinates full pipeline', () async {
      final result = await service.generateDailyPlan(featureModules: []);
      
      expect(result.dailyPlan, isNotNull);
      expect(result.dailyPlan.tasks, isEmpty); // Default mock returns empty reasoning recommendations
    });
  });
}
