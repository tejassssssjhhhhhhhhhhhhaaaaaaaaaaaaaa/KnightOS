import '../domain/knight_memory.dart';
import '../domain/memory_category.dart';
import '../domain/memory_domain.dart';
import 'memory_engine.dart';

/// Unified retrieval layer for high-performance memory queries.
/// Targets < 100ms response time.
class MemoryRetrievalEngine {
  const MemoryRetrievalEngine({required this.memoryEngine});

  final MemoryEngine memoryEngine;

  /// Retrieves memories by date range.
  Future<List<KnightMemory>> getByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    // Current MemoryEngine doesn't have a direct date range query.
    // We'll search and filter for now, but in a real app, this should be a DAO query.
    final all = await memoryEngine.search('');
    return all
        .where(
          (m) => m.effectiveAt.isAfter(start) && m.effectiveAt.isBefore(end),
        )
        .toList();
  }

  /// Retrieves the latest record for a specific logical fact (e.g. 'home_location').
  Future<KnightMemory?> getLatest(String memoryId) =>
      memoryEngine.getLatest(memoryId);

  /// Retrieves all current facts for a specific book.
  Future<List<KnightMemory>> getByCategory(BookCategory category) =>
      memoryEngine.getByCategory(category);

  /// Retrieves memories by domain.
  Future<List<KnightMemory>> getByDomain(MemoryDomain domain) =>
      memoryEngine.getByDomain(domain);

  /// Specialized: Find memories by tag.
  Future<List<KnightMemory>> getByTag(String tag) async {
    final all = await memoryEngine.search(tag);
    return all.where((m) => m.tags.contains(tag)).toList();
  }

  /// Searches memories using keywords.
  Future<List<KnightMemory>> search(String query) => memoryEngine.search(query);
}
