import 'intelligence_events.dart';
import 'intelligence_models.dart';
import 'memory_category.dart';

/// The contract for all domain-specific reasoning plugins in KnightOS.
abstract class IntelligenceModule {
  /// Unique identifier for the module (e.g. 'health_intelligence').
  String get id;

  /// The Knowledge Books this module requires for reasoning.
  List<BookCategory> get inputCategories;

  /// Priority of this module's output (higher is more important).
  double get priority;

  /// Reacts to an intelligence event.
  /// Returns list of results or empty if nothing relevant changed.
  Future<void> onEvent(IntelligenceEvent event);

  /// Generates proactive insights based on the current context.
  Future<List<IntelligenceResult>> getInsights();

  /// Generates actionable recommendations.
  Future<List<IntelligenceResult>> getRecommendations();

  /// Generates the module's contribution to the daily briefing.
  Future<List<String>> getBriefingItems();
}
