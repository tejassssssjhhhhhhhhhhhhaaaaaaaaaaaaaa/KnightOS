import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/engines/world_engine.dart';
import 'package:knight_os/core/intelligence/services/world_service.dart';
import 'package:knight_os/core/intelligence/intelligence_bus.dart';
import 'package:knight_os/core/intelligence/domain/world_models.dart';
import 'world_engine_test.dart';

void main() {
  late WorldService service;
  late WorldEngine engine;

  setUp(() {
    engine = WorldEngine(bus: IntelligenceBus());
    service = WorldService(engine: engine);
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
