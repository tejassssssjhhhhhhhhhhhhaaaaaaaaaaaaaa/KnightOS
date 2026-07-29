import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/engines/mission/progress_intelligence_engine.dart';
import 'package:knight_os/core/intelligence/engines/memory_retrieval_engine.dart';
import 'package:knight_os/core/intelligence/engines/memory_engine.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/memory_category.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';
import 'package:knight_os/core/intelligence/domain/mission_models.dart';
import 'package:knight_os/core/intelligence/services/json_validation_service.dart';
import 'package:knight_os/core/intelligence/domain/memory_relation.dart';
import 'package:knight_os/core/intelligence/domain/repositories/memory_repository.dart';

class FakeMemoryRepository implements MemoryRepository {
  List<KnightMemory> memories = [];
  @override
  Future<void> save(KnightMemory memory) async => memories.add(memory);
  @override
  Future<void> saveAll(List<KnightMemory> m) async => memories.addAll(m);
  @override
  Future<void> delete(String id) async {}
  @override
  Future<KnightMemory?> getLatest(String id) async => null;
  @override
  Future<List<KnightMemory>> getByCategory(BookCategory category) async =>
      memories.where((m) => m.category == category).toList();
  @override
  Future<List<KnightMemory>> getByDomain(dynamic domain) async => [];
  @override
  Future<List<KnightMemory>> getHistory(String id) async => [];
  @override
  Future<List<KnightMemory>> search(String query) async => memories;
  @override
  Future<void> link(
    String s,
    String t,
    String ty, {
    double strength = 1.0,
  }) async {}
  @override
  Future<List<KnightMemory>> getRelated(String id) async => [];
  @override
  Future<List<MemoryRelation>> getAllRelations() async => [];
  @override
  Stream<KnightMemory?> watchLatest(String id) => Stream.value(null);
  @override
  Stream<List<KnightMemory>> watchByCategory(BookCategory c) =>
      Stream.value([]);
  @override
  Stream<List<KnightMemory>> watchByDomain(dynamic d) => Stream.value([]);
}

class FakeValidationService implements JsonValidationService {
  @override
  String get schemaDirectory => '';
  @override
  Future<void> validate(
    MemoryDomain domain,
    Map<String, dynamic> content,
  ) async {}
}

void main() {
  late ProgressIntelligenceEngine engine;
  late MemoryEngine memoryEngine;

  setUp(() {
    memoryEngine = MemoryEngine(
      repository: FakeMemoryRepository(),
      validationService: FakeValidationService(),
    );
    engine = ProgressIntelligenceEngine(
      retrieval: MemoryRetrievalEngine(memoryEngine: memoryEngine),
    );
  });

  test(
    'ProgressIntelligenceEngine should calculate completion correctly',
    () async {
      final missionId = 'm1';

      // Add 4 goals, 2 completed
      for (int i = 0; i < 4; i++) {
        final goal = Goal(
          id: 'g$i',
          missionId: missionId,
          title: 'Goal $i',
          isCompleted: i < 2,
        );
        await memoryEngine.save(
          KnightMemory.create(
            memoryId: 'g$i',
            category: BookCategory.ambitions,
            domain: MemoryDomain.goals,
            source: MemorySource.manual,
            content: {...goal.toJson(), 'missionDataType': 'goal'},
          ),
        );
      }

      final completion = await engine.calculateCompletion(missionId);
      expect(completion, 0.5);
    },
  );
}
