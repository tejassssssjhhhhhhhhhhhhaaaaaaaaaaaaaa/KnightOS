import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/memory_category.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';
import 'package:knight_os/core/intelligence/domain/repositories/memory_repository.dart';
import 'package:knight_os/core/intelligence/engines/memory_engine.dart';
import 'package:knight_os/core/intelligence/engines/planning_engine.dart';
import 'package:knight_os/core/intelligence/engines/reasoning_engine.dart';
import 'package:knight_os/core/intelligence/engines/world_engine.dart';
import 'package:knight_os/core/intelligence/services/world_service.dart';
import 'package:knight_os/core/intelligence/intelligence_bus.dart';
import 'package:knight_os/core/intelligence/knight_context_service.dart';
import 'package:knight_os/core/intelligence/services/json_validation_service.dart';
import 'package:knight_os/core/intelligence/services/planning_service.dart';
import 'package:knight_os/core/intelligence/services/reasoning_service.dart';
import 'package:knight_os/core/intelligence/engines/context_engine.dart';
import 'package:knight_os/core/intelligence/engines/optimization_engine.dart';
import 'package:knight_os/core/intelligence/engines/ai_provider.dart';

class MockMemoryRepository extends Fake implements MemoryRepository {
  @override
  Future<List<KnightMemory>> search(String query) async => [];

  @override
  Future<List<KnightMemory>> getByCategory(BookCategory category) async => [];

  @override
  Future<List<KnightMemory>> getByDomain(MemoryDomain domain) async => [];

  @override
  Future<KnightMemory?> getLatest(String memoryId) async => null;

  @override
  Stream<KnightMemory?> watchLatest(String memoryId) => Stream.value(null);

  @override
  Stream<List<KnightMemory>> watchByCategory(BookCategory category) => Stream.value([]);

  @override
  Stream<List<KnightMemory>> watchByDomain(MemoryDomain domain) => Stream.value([]);
}

class MockJsonValidationService extends Fake implements JsonValidationService {
  @override
  Future<void> validate(MemoryDomain domain, Map<String, dynamic> content) async {}
}

class MockAiProvider extends Fake implements KnightAiProvider {}

void main() {
  late PlanningService service;
  late PlanningEngine engine;
  late MemoryEngine memoryEngine;
  late KnightContextService contextService;
  late ReasoningService reasoningService;
  late WorldService worldService;

  setUp(() {
    engine = PlanningEngine(aiProvider: MockAiProvider());
    final bus = IntelligenceBus();
    memoryEngine = MemoryEngine(
      repository: MockMemoryRepository(),
      validationService: MockJsonValidationService(),
    );
    contextService = KnightContextService();
    worldService = WorldService(
      engine: WorldEngine(bus: bus),
      memoryEngine: memoryEngine,
    );
    reasoningService = ReasoningService(
      engine: const ReasoningEngine(),
      memoryEngine: memoryEngine,
      contextService: contextService,
      worldService: worldService,
      contextEngine: ContextEngine(memoryEngine: memoryEngine),
      optimizationEngine: OptimizationEngine(bus: bus),
    );
    service = PlanningService(
      engine: engine,
      memoryEngine: memoryEngine,
      contextService: contextService,
      reasoningService: reasoningService,
      worldService: worldService,
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
