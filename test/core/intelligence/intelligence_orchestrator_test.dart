import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/intelligence_orchestrator.dart';
import 'package:knight_os/core/intelligence/intelligence_bus.dart';
import 'package:knight_os/core/intelligence/engines/memory_engine.dart';
import 'package:knight_os/core/intelligence/domain/intelligence_module.dart';
import 'package:knight_os/core/intelligence/domain/intelligence_events.dart';
import 'package:knight_os/core/intelligence/domain/intelligence_models.dart';
import 'package:knight_os/core/intelligence/domain/memory_category.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/services/json_validation_service.dart';
import 'package:knight_os/core/intelligence/domain/memory_relation.dart';
import 'package:knight_os/core/intelligence/domain/repositories/memory_repository.dart';

class MockIntelligenceModule extends IntelligenceModule {
  bool onEventCalled = false;
  IntelligenceEvent? lastEvent;

  @override
  String get id => 'mock_module';

  @override
  List<BookCategory> get inputCategories => [];

  @override
  double get priority => 1.0;

  @override
  Future<void> onEvent(IntelligenceEvent event) async {
    onEventCalled = true;
    lastEvent = event;
  }

  @override
  Future<List<IntelligenceResult>> getInsights() async => [];

  @override
  Future<List<IntelligenceResult>> getRecommendations() async => [];

  @override
  Future<List<String>> getBriefingItems() async => [];
}

class FakeMemoryRepository implements MemoryRepository {
  @override
  Future<void> save(KnightMemory memory) async {}
  @override
  Future<void> saveAll(List<KnightMemory> memories) async {}
  @override
  Future<void> delete(String memoryId) async {}
  @override
  Future<KnightMemory?> getLatest(String memoryId) async => null;
  @override
  Future<List<KnightMemory>> getByCategory(BookCategory category) async => [];
  @override
  Future<List<KnightMemory>> getByDomain(dynamic domain) async => [];
  @override
  Future<List<KnightMemory>> getHistory(String memoryId) async => [];
  @override
  Future<List<KnightMemory>> search(String query, {int? limit}) async => [];
  @override
  Future<List<KnightMemory>> searchByDateRange(DateTime start, DateTime end) async => [];
  @override
  Future<void> link(
    String s,
    String t,
    String ty, {
    double strength = 1.0,
  }) async {}
  @override
  Future<List<KnightMemory>> getRelated(String memoryId) async => [];
  @override
  Future<List<MemoryRelation>> getAllRelations() async => [];
  @override
  Stream<KnightMemory?> watchLatest(String memoryId) => Stream.value(null);
  @override
  Stream<List<KnightMemory>> watchByCategory(BookCategory category) =>
      Stream.value([]);
  @override
  Stream<List<KnightMemory>> watchByDomain(dynamic domain) => Stream.value([]);
}

void main() {
  late IntelligenceOrchestrator orchestrator;
  late IntelligenceBus bus;
  late MemoryEngine memoryEngine;
  late MockIntelligenceModule mockModule;

  setUp(() {
    bus = IntelligenceBus();
    memoryEngine = MemoryEngine(
      repository: FakeMemoryRepository(),
      validationService: JsonValidationService(schemaDirectory: ''),
    );
    mockModule = MockIntelligenceModule();

    orchestrator = IntelligenceOrchestrator(
      bus: bus,
      memoryEngine: memoryEngine,
    );
    orchestrator.registerModule(mockModule);
  });

  tearDown(() {
    bus.dispose();
    orchestrator.dispose();
  });

  test('Orchestrator should trigger module on event', () async {
    final event = ContextChangedEvent(
      timestamp: DateTime.now(),
      contextLabel: 'work',
    );

    bus.emit(event);

    // Orchestrator processes events asynchronously
    await Future.delayed(const Duration(milliseconds: 50));

    expect(mockModule.onEventCalled, true);
    expect(mockModule.lastEvent, event);
  });
}

