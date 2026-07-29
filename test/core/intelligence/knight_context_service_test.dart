import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/knight_context_service.dart';

void main() {
  late KnightContextService service;

  setUp(() {
    service = KnightContextService();
  });

  group('KnightContextService', () {
    test('buildContext populates required life context fields', () {
      final context = service.buildContext(featureModules: []);

      expect(context.timestamp, isNotNull);
      expect(context.greeting, isA<String>());
      expect(context.sleepStatus, isNotEmpty);
      expect(context.upcomingEvents, isNotEmpty);
      expect(context.currentGoals, isNotEmpty);
      expect(context.healthSummary, isNotEmpty);
      expect(context.weather, isNotEmpty);
    });

    test('calculateGreeting returns correct labels based on hour', () {
      // Mocking time via buildContext parameter
      
      // Morning: 5:00 - 11:59
      final morning = service.buildContext(
        featureModules: [],
        timestamp: DateTime(2026, 7, 28, 8, 0),
      );
      expect(morning.greeting, 'Morning');

      // Afternoon: 12:00 - 16:59
      final afternoon = service.buildContext(
        featureModules: [],
        timestamp: DateTime(2026, 7, 28, 14, 0),
      );
      expect(afternoon.greeting, 'Afternoon');

      // Evening: 17:00 - 20:59
      final evening = service.buildContext(
        featureModules: [],
        timestamp: DateTime(2026, 7, 28, 19, 0),
      );
      expect(evening.greeting, 'Evening');

      // Night: 21:00 - 4:59
      final night = service.buildContext(
        featureModules: [],
        timestamp: DateTime(2026, 7, 28, 23, 0),
      );
      expect(night.greeting, 'Night');
      
      final lateNight = service.buildContext(
        featureModules: [],
        timestamp: DateTime(2026, 7, 28, 2, 0),
      );
      expect(lateNight.greeting, 'Night');
    });

    test('buildContext allows overriding life context fields', () {
      final context = service.buildContext(
        featureModules: [],
        sleepStatus: 'Recovering from intense workout',
        weather: 'Thunderstorms',
        upcomingEvents: ['Meeting with Tejas'],
      );

      expect(context.sleepStatus, 'Recovering from intense workout');
      expect(context.weather, 'Thunderstorms');
      expect(context.upcomingEvents, contains('Meeting with Tejas'));
    });
  });
}
