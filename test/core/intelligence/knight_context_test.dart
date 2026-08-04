import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/knight_context_service.dart';
import 'package:knight_os/core/intelligence/domain/world_models.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/memory_category.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';

void main() {
  late KnightContextService contextService;

  setUp(() {
    contextService = KnightContextService();
  });

  group('KnightContextService Regression Tests', () {
    test('buildContext should return default values for empty modules', () {
      final context = contextService.buildContext(featureModules: []);

      expect(context.healthStatus, 'Active');
      expect(context.weather, 'Clear skies');
      expect(context.currentGoals, ['Stabilize core systems']);
      expect(context.energyLevel, 'High');
    });

    test('buildContext should derive goals from memories', () {
      final memories = [
        KnightMemory.create(
          memoryId: 'goal_1',
          category: BookCategory.ambitions,
          domain: MemoryDomain.goals,
          source: MemorySource.manual,
          content: {},
          summary: 'Master Flutter testing',
        ),
      ];

      final context = contextService.buildContext(
        featureModules: [],
        recentMemories: memories,
      );

      expect(context.currentGoals, contains('Master Flutter testing'));
    });

    test('buildContext should use provided world state', () {
      final worldState = WorldState(
        weather: 'Rainy',
        calendarEvents: [
           CalendarEvent(id: 'c1', title: 'Lunch with CEO', startTime: DateTime.now(), endTime: DateTime.now())
        ],
        marketStatus: 'Open',
      );

      final context = contextService.buildContext(
        featureModules: [],
        worldState: worldState,
      );

      expect(context.weather, 'Rainy');
      expect(context.upcomingEvents, contains('Lunch with CEO'));
    });
    
    test('buildContext should generate appropriate greeting based on time', () {
      final morningContext = contextService.buildContext(
        featureModules: [],
        timestamp: DateTime(2026, 8, 3, 8), // 8 AM
      );
      
      expect(morningContext.greeting.toLowerCase(), contains('morning'));

      final eveningContext = contextService.buildContext(
        featureModules: [],
        timestamp: DateTime(2026, 8, 3, 20), // 8 PM
      );
      
      expect(eveningContext.greeting.toLowerCase(), contains('evening'));
    });
  });
}
