import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/engines/world_engine.dart';
import 'package:knight_os/core/intelligence/intelligence_bus.dart';
import 'package:knight_os/core/world/adapters/calendar_connector.dart';
import 'package:knight_os/core/world/adapters/weather_connector.dart';

import 'package:knight_os/core/intelligence/domain/world_models.dart';

class MockCalendarClient implements CalendarClient {
  List<CalendarEvent> events = [];
  @override
  Future<bool> checkAuth() async => true;
  @override
  Future<List<CalendarEvent>> fetchEvents(DateTime start, DateTime end) async => events;
  @override
  Future<bool> createEvent(CalendarEvent event) async => true;
}

class MockWeatherClient implements WeatherClient {
  Map<String, dynamic> weather = {'temp': 20, 'condition': 'Clear'};
  @override
  Future<Map<String, dynamic>> getCurrentWeather() async => weather;
  @override
  Future<bool> isOnline() async => true;
}

void main() {
  late WorldEngine engine;
  late MockCalendarClient calClient;
  late MockWeatherClient weatherClient;

  setUp(() {
    engine = WorldEngine(bus: IntelligenceBus());
    calClient = MockCalendarClient();
    weatherClient = MockWeatherClient();
    
    engine.registerConnector(GoogleCalendarConnector(client: calClient));
    engine.registerConnector(OpenWeatherConnector(client: weatherClient));
  });

  group('Autonomous World Perception (Sprint 1.2)', () {
    test('perceive merges data from parallel connectors', () async {
      calClient.events = [
        CalendarEvent(
          id: '1',
          title: 'Event 1',
          startTime: DateTime.now(),
          endTime: DateTime.now().add(const Duration(hours: 1)),
        )
      ];
      weatherClient.weather = {'temp': 25, 'condition': 'Sunny'};

      final result = await engine.perceive();

      expect(result.state.weather, '25°C, Sunny');
      expect(result.state.upcomingEvents, contains('Event 1'));
    });

    test('change detector identifies state shifts and generates diffs', () async {
      // Pass 1: Baseline
      await engine.perceive();

      // Pass 2: Change
      weatherClient.weather = {'temp': 10, 'condition': 'Stormy'};
      
      final result = await engine.perceive();

      expect(result.diff, anyElement(contains('OpenWeather')));
      expect(result.events.any((e) => e.sourceId == 'open-weather'), isTrue);
    });

    test('normalization creates history memories for calendar events', () async {
      calClient.events = [
        CalendarEvent(
          id: '2',
          title: 'Lunch with Team',
          startTime: DateTime.now(),
          endTime: DateTime.now().add(const Duration(hours: 1)),
        )
      ];
      
      final result = await engine.perceive();

      expect(result.memories.any((m) => (m.summary ?? '').contains('Lunch')), isTrue);
      expect(result.memories.first.metadata.provenance, 'google-calendar');
    });
  });
}
