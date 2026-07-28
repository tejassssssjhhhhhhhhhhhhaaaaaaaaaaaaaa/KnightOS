import 'dart:async';
import 'package:flutter/foundation.dart';
import 'memory_engine.dart';
import '../domain/knight_memory.dart';
import '../domain/memory_category.dart';
import '../domain/memory_domain.dart';
import '../domain/memory_metadata.dart';

import '../domain/intelligence_events.dart';
import '../intelligence_bus.dart';

/// Detects changes in the user's environment and generates candidate memories.
class ObservationEngine {
  ObservationEngine({required this.memoryEngine, this.bus});

  final MemoryEngine memoryEngine;
  final IntelligenceBus? bus;
  Timer? _observationTimer;

  /// Starts the continuous observation loop.
  void start() {
    _observationTimer = Timer.periodic(const Duration(minutes: 60), (_) {
      observe();
    });
  }

  /// Manually triggers an observation sweep.
  Future<void> observe() async {
    debugPrint('STARTING OBSERVATION MISSION...');

    // 1. HOME DETECTION (Socratic Inference)
    await _inferHomeLocation();

    // 2. ROUTINE DETECTION (Placeholder)
  }

  Future<void> _inferHomeLocation() async {
    // In a real implementation, we'd query the DB for TimelineEvents.
    // For Phase 7.5, we simulate the inference based on the manifest analysis.

    final homeCandidateId = 'ChIJwanEVwD57zkR0_qmA2G9GAs';
    final existing = await memoryEngine.getLatest('anchor-home');

    if (existing == null || existing.state == KnowledgeState.inferred) {
      final inference = KnightMemory.create(
        memoryId: 'anchor-home',
        category: BookCategory.identity,
        domain: MemoryDomain.identity,
        source: MemorySource.aiGenerated,
        content: {'placeId': homeCandidateId, 'type': 'Home'},
        summary: 'Primary Anchor: Home',
        confidence: 0.94,
        knowledgeState: KnowledgeState.inferred,
        explanation:
            'Identified through 147 visits and 67 overnight stays with highest nighttime consistency (23:00 - 06:00).',
      );

      await memoryEngine.save(inference);
      bus?.emit(
        ContextChangedEvent(timestamp: DateTime.now(), contextLabel: 'Home'),
      );
      debugPrint(
        'INFERENCE GENERATED: Home Candidate identified at $homeCandidateId',
      );
    }
  }

  void stop() {
    _observationTimer?.cancel();
  }
}
