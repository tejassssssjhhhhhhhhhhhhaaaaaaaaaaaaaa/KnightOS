import '../services/graph_query_service.dart';

/// The Universal Intelligence Contract defines how intelligence modules
/// interact with the Knight OS Knowledge Graph.
abstract class IntelligenceContract {
  /// Unique ID for this intelligence module.
  String get moduleId;

  /// The Graph Query Service provided by the platform.
  GraphQueryService get graph;

  /// Triggered when the module needs to perform a reasoning cycle.
  Future<void> onReasoningCycle();

  /// Triggered when the module needs to validate graph integrity for its domain.
  Future<void> onValidationCycle();
}
