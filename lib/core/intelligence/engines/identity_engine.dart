import '../domain/knight_memory.dart';
import '../domain/memory_category.dart';
import '../domain/memory_domain.dart';
import 'memory_engine.dart';

/// Manages permanent and rarely changing information about the user.
class IdentityEngine {
  const IdentityEngine({required this.memoryEngine});

  final MemoryEngine memoryEngine;

  /// Retrieves the current consolidated identity of the user.
  Future<List<KnightMemory>> getFullIdentity() {
    return memoryEngine.getByCategory(BookCategory.identity);
  }

  /// Records a new identity fact.
  Future<void> defineFact({
    required String key,
    required Map<String, dynamic> data,
    String? summary,
    double importance = 0.9,
  }) async {
    final memory = KnightMemory.create(
      memoryId: 'identity-$key',
      category: BookCategory.identity,
      domain: MemoryDomain.identity,
      content: data,
      summary: summary,
      source: MemorySource.manual,
      importance: importance,
    );
    await memoryEngine.save(memory);
  }

  /// Records a core user value or preference.
  Future<void> setPreference(String key, dynamic value) {
    return defineFact(key: 'pref-$key', data: {'key': key, 'value': value});
  }

  /// Records a career-related identity fact.
  Future<void> updateCareer(String role, String company) {
    return defineFact(
      key: 'career',
      data: {'role': role, 'company': company},
      summary: 'Current role: $role at $company',
    );
  }
}
