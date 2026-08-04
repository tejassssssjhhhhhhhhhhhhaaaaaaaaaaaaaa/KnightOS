import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/engines/health/sleep_intelligence.dart';
import 'package:knight_os/core/intelligence/engines/health/fitness_intelligence.dart';
import 'package:knight_os/core/intelligence/engines/memory_retrieval_engine.dart';
import 'package:knight_os/core/intelligence/engines/memory_engine.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/memory_category.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';
import 'package:knight_os/core/intelligence/domain/health_models.dart';
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
  Future<List<KnightMemory>> getByDomain(dynamic domain) async =>
      memories.where((m) => m.metadata.domain == domain).toList();
  @override
  Future<List<KnightMemory>> getHistory(String id) async => [];
  @override
  Future<List<KnightMemory>> search(String query) async => memories;
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
  late MemoryEngine memoryEngine;
  late MemoryRetrievalEngine retrieval;
  late FakeMemoryRepository repository;

  setUp(() {
    repository = FakeMemoryRepository();
    memoryEngine = MemoryEngine(
      repository: repository,
      validationService: FakeValidationService(),
    );
    retrieval = MemoryRetrievalEngine(memoryEngine: memoryEngine);
  });

  test('SleepIntelligence should detect sleep debt', () async {
    final sleepInt = SleepIntelligence(retrieval: retrieval);

    // Add 7 days of 6h sleep (Debt = 2h/day = 14h total)
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      final start = now.subtract(Duration(days: i, hours: 8));
      final end = start.add(const Duration(hours: 6));
      final record = SleepRecord(
        start: start,
        end: end,
        durationMinutes: 360,
        quality: 0.7,
      );

      final memory = KnightMemory.create(
        memoryId: 'sleep-$i',
        category: BookCategory.health,
        domain: MemoryDomain.health,
        source: MemorySource.manual,
        content: {
          ...record.toJson(),
          'healthDataType': HealthDataType.sleep.name,
        },
        summary: 'Slept 6h',
        effectiveAt: start,
      );
      await memoryEngine.save(memory);
    }

    final analysis = await sleepInt.analyzeSleep();
    expect(analysis['debtHours'], 2.0);

    final insights = await sleepInt.getInsights();
    expect(insights.length, 1);
    expect(insights.first.id, 'insight-sleep-debt');
  });

  test('FitnessIntelligence should detect workout streak', () async {
    final fitnessInt = FitnessIntelligence(retrieval: retrieval);
    final now = DateTime.now();

    for (int i = 0; i < 3; i++) {
      final timestamp = now.subtract(Duration(days: i));
      final record = ExerciseRecord(
        workoutType: 'Strength',
        durationMinutes: 45,
        caloriesBurned: 300,
        isStrength: true,
        timestamp: timestamp,
      );

      final memory = KnightMemory.create(
        memoryId: 'workout-$i',
        category: BookCategory.health,
        domain: MemoryDomain.health,
        source: MemorySource.manual,
        content: {
          ...record.toJson(),
          'healthDataType': HealthDataType.exercise.name,
        },
        summary: 'Workout day $i',
        effectiveAt: timestamp,
      );
      await memoryEngine.save(memory);
    }

    final analysis = await fitnessInt.analyzeFitness();
    expect(analysis['streak'], 3);

    final insights = await fitnessInt.getInsights();
    expect(insights.length, 1);
    expect(insights.first.id, 'insight-fitness-streak');
  });
}
