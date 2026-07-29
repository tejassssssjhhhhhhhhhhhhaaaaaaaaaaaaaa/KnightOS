import '../domain/knight_memory.dart';
import '../domain/memory_domain.dart';
import '../domain/memory_category.dart';
import '../domain/memory_relation.dart';
import '../domain/repositories/memory_repository.dart';
import '../services/json_validation_service.dart';
import '../domain/intelligence_events.dart';
import '../intelligence_bus.dart';

/// The central logic engine for memory operations, enforcing validation
/// and constitutional rules before persistence.
class MemoryEngine {
  const MemoryEngine({
    required this.repository,
    required this.validationService,
    this.bus,
  });

  final MemoryRepository repository;
  final JsonValidationService validationService;
  final IntelligenceBus? bus;

  /// Retrieves the current state of a fact chain.
  Future<KnightMemory?> getLatest(String memoryId) =>
      repository.getLatest(memoryId);

  /// Retrieves all current facts for a specific domain.
  Future<List<KnightMemory>> getByDomain(MemoryDomain domain) =>
      repository.getByDomain(domain);

  /// Retrieves all current facts for a specific category.
  Future<List<KnightMemory>> getByCategory(BookCategory category) =>
      repository.getByCategory(category);

  /// Commits a new memory. Validates content against ontology schemas.
  Future<void> save(KnightMemory memory) async {
    // 1. Logic Validation (Schema)
    await validationService.validate(memory.metadata.domain, memory.content);

    // 2. Persistence
    await repository.save(memory);

    // 3. Emit Event
    bus?.emit(DataChangedEvent(timestamp: DateTime.now(), memories: [memory]));

    // 4. TODO: Trigger Knowledge Graph update (Sprint 2)
    // 5. TODO: Trigger Book Synthesis (Sprint 3)
  }

  /// Commits multiple memories in bulk.
  Future<void> saveAll(List<KnightMemory> memories) async {
    // 1. Logic Validation (Schema) - Batch
    for (final memory in memories) {
      await validationService.validate(memory.metadata.domain, memory.content);
    }

    // 2. Persistence
    await repository.saveAll(memories);

    // 3. Emit Event
    bus?.emit(DataChangedEvent(timestamp: DateTime.now(), memories: memories));
  }

  /// Retrieves the history of changes for a specific fact.
  Future<List<KnightMemory>> getHistory(String memoryId) =>
      repository.getHistory(memoryId);

  /// Searches for memories.
  Future<List<KnightMemory>> search(String query) => repository.search(query);

  /// Deletes a memory chain.
  Future<void> delete(String memoryId) => repository.delete(memoryId);

  /// Links two memories in the graph.
  Future<void> link(
    String sourceId,
    String targetId,
    String type, {
    double strength = 1.0,
  }) => repository.link(sourceId, targetId, type, strength: strength);

  /// Retrieves all memories related to the given ID.
  Future<List<KnightMemory>> getRelated(String memoryId) =>
      repository.getRelated(memoryId);

  /// Retrieves all relationship edges.
  Future<List<MemoryRelation>> getAllRelations() =>
      repository.getAllRelations();

  /// --- Reactive APIs (ADR-002) ---

  /// Watches the latest state of a specific memory.
  Stream<KnightMemory?> watchLatest(String memoryId) =>
      repository.watchLatest(memoryId);

  /// Watches all current facts for a specific domain.
  Stream<List<KnightMemory>> watchByDomain(MemoryDomain domain) =>
      repository.watchByDomain(domain);

  /// Watches all current facts for a specific book category.
  Stream<List<KnightMemory>> watchByCategory(BookCategory category) =>
      repository.watchByCategory(category);
}
