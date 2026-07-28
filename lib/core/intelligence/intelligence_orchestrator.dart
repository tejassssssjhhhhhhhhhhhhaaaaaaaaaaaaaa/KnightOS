import 'dart:async';
import 'domain/intelligence_module.dart';
import 'domain/intelligence_events.dart';
import 'domain/intelligence_models.dart';
import 'domain/knight_memory.dart';
import 'domain/memory_category.dart';
import 'domain/memory_domain.dart';
import 'intelligence_bus.dart';
import 'engines/memory_engine.dart';
import '../internal/utils/knight_logger.dart';

/// The brain of KnightOS. Coordinates all specialized intelligence engines.
class IntelligenceOrchestrator {
  IntelligenceOrchestrator({required this.bus, required this.memoryEngine}) {
    _init();
  }

  final IntelligenceBus bus;
  final MemoryEngine memoryEngine;
  final List<IntelligenceModule> _modules = [];
  final Map<String, List<IntelligenceResult>> _insightCache = {};
  final Map<String, List<IntelligenceResult>> _recommendationCache = {};

  StreamSubscription? _eventSub;

  void _init() {
    _eventSub = bus.events.listen(_handleEvent);
  }

  /// Registers a new intelligence module.
  void registerModule(IntelligenceModule module) {
    _modules.add(module);
    _modules.sort((a, b) => b.priority.compareTo(a.priority));
  }

  Future<void> _handleEvent(IntelligenceEvent event) async {
    KnightLogger.info(
      'Orchestrator handling event: ${event.runtimeType}',
      category: KnightLogCategory.intelligence,
    );

    // In a production app, we would parallelize this with Isolates for heavy work.
    for (final module in _modules) {
      try {
        await module.onEvent(event);

        // Update caches after event processing
        _insightCache[module.id] = await module.getInsights();
        _recommendationCache[module.id] = await module.getRecommendations();
      } catch (e, stack) {
        KnightLogger.error(
          'Module ${module.id} failed to process event: $e',
          error: e,
          stackTrace: stack,
          category: KnightLogCategory.intelligence,
        );
      }
    }
  }

  /// Returns all cached insights from all modules, ranked.
  Future<List<IntelligenceResult>> getAllInsights() async {
    final List<IntelligenceResult> all = [];
    for (final insights in _insightCache.values) {
      all.addAll(insights);
    }

    // RANKING ENGINE LOGIC
    all.sort((a, b) {
      // 1. Confidence Weight
      final scoreA = a.trace.confidence;
      final scoreB = b.trace.confidence;

      // 2. Freshness (Simulated)

      // 3. Feedback Penalty
      final feedbackA = a.feedback == IntelligenceFeedback.notHelpful
          ? 0.5
          : 1.0;
      final feedbackB = b.feedback == IntelligenceFeedback.notHelpful
          ? 0.5
          : 1.0;

      return (scoreB * feedbackB).compareTo(scoreA * feedbackA);
    });

    return all;
  }

  /// Returns all cached recommendations.
  Future<List<IntelligenceResult>> getAllRecommendations() async {
    final List<IntelligenceResult> all = [];
    for (final recs in _recommendationCache.values) {
      all.addAll(recs);
    }
    return all;
  }

  /// Generates a unified daily briefing.
  Future<Map<String, List<String>>> getDailyBriefing() async {
    final Map<String, List<String>> briefing = {};
    for (final module in _modules) {
      briefing[module.id] = await module.getBriefingItems();
    }
    return briefing;
  }

  /// Records a reasoning milestone to the persistent memory.
  Future<void> logMilestone({
    required String title,
    required String summary,
    required IntelligenceEntryType type,
    required double confidence,
    List<String> evidenceIds = const [],
  }) async {
    final memory = KnightMemory.create(
      memoryId: 'milestone-${DateTime.now().millisecondsSinceEpoch}',
      category: BookCategory.history,
      domain: MemoryDomain.memories,
      source: MemorySource.aiGenerated,
      content: {
        'title': title,
        'summary': summary,
        'type': type.name,
        'confidence': confidence,
        'evidenceIds': evidenceIds,
      },
      summary: title,
      effectiveAt: DateTime.now(),
      tags: ['intelligence_milestone'],
      confidence: confidence,
    );

    await memoryEngine.save(memory);
  }

  /// Submits user feedback for a specific intelligence item.
  void submitFeedback(String intelligenceId, IntelligenceFeedback feedback) {
    bus.emit(
      FeedbackReceivedEvent(
        timestamp: DateTime.now(),
        intelligenceId: intelligenceId,
        feedback: feedback,
      ),
    );

    // Future: Persist feedback to Memory Engine for long-term learning.
  }

  void dispose() {
    _eventSub?.cancel();
  }
}
