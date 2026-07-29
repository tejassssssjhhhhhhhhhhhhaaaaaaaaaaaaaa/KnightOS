import 'package:flutter/foundation.dart';
import 'knight_memory.dart';

/// Represents a single item found during a universal search.
@immutable
class SearchResult {
  const SearchResult({
    required this.id,
    required this.title,
    this.snippet,
    required this.relevance,
    required this.confidence,
    required this.timestamp,
    this.sourceMemory,
    this.metadata = const {},
  });

  final String id;
  final String title;
  final String? snippet;
  final double relevance; // 0.0 to 1.0
  final double confidence; // 0.0 to 1.0
  final DateTime timestamp;
  final KnightMemory? sourceMemory;
  final Map<String, dynamic> metadata;
}

/// Categorized collection of search results.
@immutable
class SearchCollection {
  const SearchCollection({
    required this.query,
    required this.results,
    required this.suggestedIntent,
    required this.latencyMs,
  });

  final String query;
  final List<SearchResult> results;
  final String suggestedIntent;
  final int latencyMs;
}
