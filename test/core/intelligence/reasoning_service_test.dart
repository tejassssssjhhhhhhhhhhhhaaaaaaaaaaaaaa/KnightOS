import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/engines/reasoning_engine.dart';
import 'package:knight_os/core/intelligence/services/reasoning_service.dart';
import 'package:knight_os/core/intelligence/engines/memory_engine.dart';
import 'package:knight_os/core/intelligence/knight_context_service.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/memory_category.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';
import 'package:knight_os/core/intelligence/domain/repositories/memory_repository.dart';
import 'package:knight_os/core/intelligence/services/json_validation_service.dart';
import 'package:knight_os/core/platform/engine/feature_interfaces.dart';

class MockMemoryRepository extends Fake implements MemoryRepository {
  @override
  Future<List<KnightMemory>> search(String query) async => [];
}

class MockJsonValidationService extends Fake implements JsonValidationService {
  @override
  Future<void> validate(MemoryDomain domain, Map<String, dynamic> content) async {}
}

void main() {
  late ReasoningService service;
  late ReasoningEngine engine;
  late MemoryEngine memoryEngine;
  late KnightContextService contextService;

  setUp(() {
    engine = const ReasoningEngine();
    memoryEngine = MemoryEngine(
      repository: MockMemoryRepository(),
      validationService: MockJsonValidationService(),
    );
    contextService = KnightContextService();
    service = ReasoningService(
      engine: engine,
      memoryEngine: memoryEngine,
      contextService: contextService,
    );
  });

  group('ReasoningService', () {
    test('performReasoningCycle assembles data and returns result', () async {
      final result = await service.performReasoningCycle(featureModules: []);
      
      expect(result.summary, isNotEmpty);
      expect(result.trace.confidence, greaterThan(0));
    });
  });
}
