/// Immutable search models for the generic KnightOS feature module platform.
///
/// These models define a typed search vocabulary that future modules can adopt
/// without the engine knowing module-specific search semantics.
library;

/// Immutable search query used by feature modules.
class KnightSearchQuery {
  /// Creates a typed search query.
  const KnightSearchQuery({
    required this.moduleId,
    required this.text,
    this.filters = const <KnightSearchFilter>[],
    this.sort = KnightSearchSort.relevance,
    this.page = 0,
    this.pageSize = 20,
    this.offlineOnly = false,
    this.aiAssisted = false,
  });

  /// Owning module identifier.
  final String moduleId;

  /// Text entered by the user.
  final String text;

  /// Typed filters applied to the search.
  final List<KnightSearchFilter> filters;

  /// Sort strategy to use.
  final KnightSearchSort sort;

  /// Zero-based page index for pagination.
  final int page;

  /// Page size for pagination.
  final int pageSize;

  /// Whether the search should be limited to offline-capable data.
  final bool offlineOnly;

  /// Whether AI-assisted ranking or expansion is requested.
  final bool aiAssisted;
}

/// Immutable filter used by search providers.
class KnightSearchFilter {
  /// Creates a typed search filter.
  const KnightSearchFilter({
    required this.field,
    required this.operator,
    required this.value,
  });

  /// Field to filter on.
  final String field;

  /// Filter operator.
  final KnightSearchFilterOperator operator;

  /// Filter value.
  final String value;
}

/// Supported filter operators for search.
enum KnightSearchFilterOperator {
  /// Equal to.
  equals,

  /// Not equal to.
  notEquals,

  /// Contains.
  contains,

  /// Greater than.
  greaterThan,

  /// Less than.
  lessThan,
}

/// Supported sort strategies for search.
enum KnightSearchSort {
  /// Relevance-based ordering.
  relevance,

  /// Chronological ordering.
  chronological,

  /// Alphabetical ordering.
  alphabetical,

  /// Score-based ordering.
  score,
}

/// Immutable search-result item.
class KnightSearchResult {
  /// Creates a typed search result.
  const KnightSearchResult({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.summary,
    this.score = 0.0,
    this.metadata = const <String, String>{},
  });

  /// Stable identifier of the result.
  final String id;

  /// Owning module identifier.
  final String moduleId;

  /// Human-readable title.
  final String title;

  /// Short summary of the result.
  final String summary;

  /// Relevance or confidence score.
  final double score;

  /// Additional metadata for the result.
  final Map<String, String> metadata;
}

/// Immutable search page for paginated results.
class KnightSearchPage {
  /// Creates a typed search page.
  const KnightSearchPage({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });

  /// Results on this page.
  final List<KnightSearchResult> items;

  /// Current zero-based page index.
  final int page;

  /// Requested page size.
  final int pageSize;

  /// Whether more pages are available.
  final bool hasMore;
}
