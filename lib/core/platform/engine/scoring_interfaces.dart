/// Contracts for the KnightOS scoring system.
///
/// These interfaces allow feature modules to contribute score inputs without the
/// engine itself needing to know feature-specific implementation details.
library;

import 'scoring_models.dart';

/// Contract for a provider that contributes a score input.
abstract class KnightScoreProvider {
  /// Stable identifier for the provider.
  String get id;

  /// Human-readable name used for diagnostics and registration.
  String get name;

  /// Returns the category handled by this provider.
  KnightScoreCategory get category;

  /// Requests a score input from the provider.
  ///
  /// Implementations should return a typed score value or throw a domain error
  /// if the input cannot be produced.
  Future<KnightScoreValue> requestScore();
}

/// Contract for aggregating one or more score inputs.
abstract class KnightScoreAggregator {
  /// Aggregates the supplied score values into a single snapshot.
  ///
  /// Implementations may compose, normalize, or validate the values without
  /// introducing feature-specific business logic here.
  Future<KnightScoreSnapshot> aggregateScores(List<KnightScoreValue> values);
}

/// Contract for exposing a read-only scoring view.
abstract class KnightScoreStore {
  /// Returns the current scoring snapshots.
  Future<List<KnightScoreSnapshot>> getSnapshots();
}
