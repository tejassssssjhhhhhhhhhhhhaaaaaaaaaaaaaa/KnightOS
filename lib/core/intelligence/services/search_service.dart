import '../engines/unified_search_layer.dart';
import '../domain/search_models.dart';

/// Public API for universal search across KnightOS.
class SearchService {
  const SearchService({required this.layer});

  final UnifiedSearchLayer layer;

  /// Universal natural language query.
  Future<SearchCollection> query(String text) => layer.search(text);

  /// Clears search caches or performs maintenance.
  void clear() {
    // Placeholder
  }
}
