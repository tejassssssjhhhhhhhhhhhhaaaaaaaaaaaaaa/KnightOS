import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/services/perception_scheduler.dart';
import 'package:knight_os/core/intelligence/services/world_service.dart';
import 'package:knight_os/core/intelligence/engines/world_engine.dart';
import 'package:knight_os/core/intelligence/intelligence_bus.dart';
import 'package:knight_os/core/intelligence/domain/world_models.dart';
import 'package:knight_os/core/intelligence/engines/memory_engine.dart';
import 'package:knight_os/core/intelligence/domain/repositories/memory_repository.dart';
import 'package:knight_os/core/intelligence/services/json_validation_service.dart';

class MockMemoryRepository extends Fake implements MemoryRepository {
  @override
  Future<void> saveAll(List<dynamic> memories) async {}
}

class MockWorldService extends WorldService {
  MockWorldService({required super.engine, required super.memoryEngine});
  int syncCount = 0;
  @override
  Future<WorldResult> syncWorld() async {
    syncCount++;
    return super.syncWorld();
  }
}

void main() {
  late PerceptionScheduler scheduler;
  late MockWorldService worldService;

  setUp(() {
    final bus = IntelligenceBus();
    final mem = MemoryEngine(
      repository: MockMemoryRepository(),
      validationService: Fake(),
    );
    final engine = WorldEngine(bus: bus);
    worldService = MockWorldService(engine: engine, memoryEngine: mem);
    scheduler = PerceptionScheduler(worldService: worldService);
  });

  group('Perception Scheduler (Sprint 2.3)', () {
    test('start initiates a periodic timer', () async {
      scheduler.start(interval: const Duration(milliseconds: 100));
      
      await Future.delayed(const Duration(milliseconds: 250));
      
      expect(worldService.syncCount, greaterThanOrEqualTo(2));
      scheduler.stop();
    });

    test('stop cancels the timer', () async {
      scheduler.start(interval: const Duration(milliseconds: 100));
      scheduler.stop();
      
      final countAtStop = worldService.syncCount;
      await Future.delayed(const Duration(milliseconds: 200));
      
      expect(worldService.syncCount, countAtStop);
    });
  });
}
