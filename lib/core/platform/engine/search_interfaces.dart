/// Search contracts for the generic KnightOS feature module platform.
///
/// These interfaces allow future modules to expose search behavior without the
/// engine knowing module-specific search semantics.
library;

import 'search_models.dart';

/// Contract for a provider that can answer search requests.
abstract class KnightSearchProvider {
  /// Stable identifier for the provider.
  String get id;

  /// Human-readable name used for diagnostics.
  String get name;

  /// Module identifier associated with the provider.
  String get moduleId;

  /// Performs search using the supplied typed query.
  Future<KnightSearchPage> search(KnightSearchQuery query);

  /// Returns a list of available search suggestions for the supplied query.
  Future<List<String>> suggest(KnightSearchQuery query);
}

/// Contract for typed search filtering.
abstract class KnightSearchFilterer {
  /// Applies a typed filter to the supplied results.
  List<KnightSearchResult> filter(
    List<KnightSearchResult> items,
    List<KnightSearchFilter> filters,
  );
}

/// Contract for typed search sorting.
abstract class KnightSearchSorter {
  /// Sorts the supplied results using the supplied sort strategy.
  List<KnightSearchResult> sort(
    List<KnightSearchResult> items,
    KnightSearchSort sort,
  );
}

/// Contract for paginated search execution.
abstract class KnightSearchPaginator {
  /// Returns a page of results for the supplied request.
  KnightSearchPage paginate(
    List<KnightSearchResult> items,
    int page,
    int pageSize,
  );
}
