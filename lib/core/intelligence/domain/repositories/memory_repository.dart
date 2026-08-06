import '../knight_memory.dart';
import '../memory_domain.dart';
import '../memory_category.dart';
import '../memory_relation.dart';

/// Contract for Atomic Memory Unit (AMU) persistence and versioning.
abstract class MemoryRepository {
  /// Retrieves the latest state of a specific memory by its logical ID.
  Future<KnightMemory?> getLatest(String memoryId);

  /// Retrieves the current state for a specific domain.
  Future<List<KnightMemory>> getByDomain(MemoryDomain domain);

  /// Retrieves the current state for a specific book category.
  Future<List<KnightMemory>> getByCategory(BookCategory category);

  /// Retrieves the full evolution history of a memory chain.
  Future<List<KnightMemory>> getHistory(String memoryId);

  /// Commits a new memory version. Implementation must ensure atomicity
  /// and update the `isLatest` flag on the predecessor.
  Future<void> save(KnightMemory memory);

  /// Commits multiple memories in a single atomic transaction.
  Future<void> saveAll(List<KnightMemory> memories);

  /// Searches memories by tags or keywords.
  Future<List<KnightMemory>> search(String query, {int? limit});

  /// Searches memories by date range.
  Future<List<KnightMemory>> searchByDateRange(DateTime start, DateTime end);

  /// Deletes a memory chain (Admin/Owner only).
  Future<void> delete(String memoryId);

  /// Links two memories in the graph.
  Future<void> link(
    String sourceId,
    String targetId,
    String type, {
    double strength = 1.0,
  });

  /// Retrieves all memories related to the given ID.
  Future<List<KnightMemory>> getRelated(String memoryId);

  /// Retrieves all relationship edges in the graph.
  Future<List<MemoryRelation>> getAllRelations();

  /// --- Reactive APIs (ADR-002) ---

  /// Watches the latest state of a specific memory.
  Stream<KnightMemory?> watchLatest(String memoryId);

  /// Watches all current facts for a specific domain.
  Stream<List<KnightMemory>> watchByDomain(MemoryDomain domain);

  /// Watches all current facts for a specific category.
  Stream<List<KnightMemory>> watchByCategory(BookCategory category);
}
