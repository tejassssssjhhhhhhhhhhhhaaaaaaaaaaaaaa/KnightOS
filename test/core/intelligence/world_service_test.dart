import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/engines/world_engine.dart';
import 'package:knight_os/core/intelligence/services/world_service.dart';
import 'package:knight_os/core/intelligence/intelligence_bus.dart';
import 'package:knight_os/core/intelligence/engines/memory_engine.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';
import 'package:knight_os/core/intelligence/services/json_validation_service.dart';
import 'package:knight_os/core/intelligence/domain/repositories/memory_repository.dart';
import 'world_engine_test.dart';

class MockMemoryRepository extends Fake implements MemoryRepository {
  @override
  Future<void> saveAll(List<dynamic> memories) async {}
}

class MockJsonValidationService extends Fake implements JsonValidationService {
  @override
  Future<void> validate(MemoryDomain domain, Map<String, dynamic> content) async {}
}

void main() {
  late WorldService service;
  late WorldEngine engine;
  late MemoryEngine memoryEngine;

  setUp(() {
    engine = WorldEngine(bus: IntelligenceBus());
    memoryEngine = MemoryEngine(
      repository: MockMemoryRepository(),
      validationService: MockJsonValidationService(),
    );
    service = WorldService(engine: engine, memoryEngine: memoryEngine);
  });

  group('WorldService', () {
    test('syncWorld updates currentState', () async {
      engine.registerConnector(TestWeatherConnector());
      
      expect(service.currentState.weather, 'Unknown');
      
      final result = await service.syncWorld();
      
      expect(service.currentState.weather, 'Sunny, 24°C');
      expect(result.state, service.currentState);
    });

    test('registerConnector adds to engine', () async {
      final connector = TestWeatherConnector();
      service.registerConnector(connector);
      
      final result = await service.syncWorld();
      expect(result.state.weather, 'Sunny, 24°C');
    });
  });
}
