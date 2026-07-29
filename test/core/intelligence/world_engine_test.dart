import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/engines/world_engine.dart';
import 'package:knight_os/core/intelligence/domain/world_models.dart';
import 'package:knight_os/core/intelligence/intelligence_bus.dart';
import 'package:knight_os/core/world/domain/world_connector.dart';

class TestConnector implements WorldConnector {
  TestConnector({required Map<String, dynamic> initialData}) : _data = initialData;
  Map<String, dynamic> _data;

  set data(Map<String, dynamic> value) => _data = value;

  @override
  String get id => 'test';
  @override
  String get name => 'Test';
  @override
  WorldSource get source => const WorldSource(id: 'test-src', name: 'Test Source', type: 'test');
  @override
  Future<Map<String, dynamic>> fetchData() async => _data;
  @override
  Future<bool> isAvailable() async => true;
}

void main() {
  late WorldEngine engine;
  late IntelligenceBus bus;

  setUp(() {
    bus = IntelligenceBus();
    engine = WorldEngine(bus: bus);
  });

  group('WorldEngine', () {
    test('perceive aggregates data from connectors', () async {
      engine.registerConnector(TestConnector(initialData: {'current': 'Sunny'}));
      
      // Override the id to 'weather' for the test to verify mapping
      final weatherConnector = TestWeatherConnector();
      engine.registerConnector(weatherConnector);

      final result = await engine.perceive();

      expect(result.state.weather, 'Sunny, 24°C');
      expect(result.timestamp, isNotNull);
    });

    test('normalization creates KnightMemory units', () async {
      final calendarConnector = TestCalendarConnector();
      engine.registerConnector(calendarConnector);

      final result = await engine.perceive();

      expect(result.memories, isNotEmpty);
      expect(result.memories.first.summary, contains('Meeting'));
    });

    test('detectChange produces WorldEvent on data shift', () async {
      final connector = MutableConnector(initialData: {'items': ['A']});
      engine.registerConnector(connector);

      // First pass to establish baseline
      await engine.perceive();

      // Update data
      connector.data = {'items': ['B']};
      
      final result = await engine.perceive();

      expect(result.events, isNotEmpty);
      expect(result.events.first.type, 'data_changed');
    });
  });
}

class TestWeatherConnector extends TestConnector {
  TestWeatherConnector() : super(initialData: {'current': 'Sunny, 24°C'});
  @override
  String get id => 'weather';
}

class TestCalendarConnector extends TestConnector {
  TestCalendarConnector() : super(initialData: {'items': ['Meeting @ 10']});
  @override
  String get id => 'calendar';
}

class MutableConnector extends TestConnector {
  MutableConnector({required super.initialData});
}
