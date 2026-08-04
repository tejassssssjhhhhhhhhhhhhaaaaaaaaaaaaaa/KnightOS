import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../internal/utils/knight_logger.dart';
import '../knight_context_models.dart';
import '../domain/context_platform_models.dart';
import '../../providers/database_provider.dart';

/// The Universal Context Engine manages real-time awareness and context history.
class ContextEngine {
  ContextEngine({required this.db});
  final KnightDatabase db;

  final _candidateController = StreamController<MemoryCandidate>.broadcast();
  final _decisionController = StreamController<DecisionInput>.broadcast();

  Stream<MemoryCandidate> get memoryCandidates => _candidateController.stream;
  Stream<DecisionInput> get decisionInputs => _decisionController.stream;

  /// Performs context fusion from various contributions.
  Future<KnightContext> fuse(List<ContextContribution> contributions, KnightContext current) async {
    // Basic fusion logic: Latest contribution wins per field
    // Future: Weighted average based on confidence and source reliability.
    
    KnightLogger.info('[CONTEXT] Fusing ${contributions.length} contributions...');
    
    // Process contributions (Simulated for foundation)
    for (final contrib in contributions) {
       _auditFusion(contrib);
    }

    return current; // Return updated context
  }

  /// Records the current context to history.
  Future<void> recordHistory(KnightContext context, {double healthScore = 1.0}) async {
    try {
      await db.into(db.contextHistoryTable).insert(ContextHistoryTableCompanion.insert(
        id: 'ctx-${DateTime.now().millisecondsSinceEpoch}',
        timestamp: Value(context.timestamp),
        contextJson: jsonEncode(_serializeContext(context)),
        healthScore: healthScore,
        platformVersion: '1.0.0',
      ));
    } catch (e) {
      KnightLogger.error('[CONTEXT] Failed to record history', error: e);
    }
  }

  /// Captures a named snapshot of the current context.
  Future<void> captureSnapshot(String name, KnightContext context) async {
    await db.into(db.contextSnapshotsTable).insert(ContextSnapshotsTableCompanion.insert(
      id: 'snap-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      timestamp: Value(DateTime.now()),
      contextJson: jsonEncode(_serializeContext(context)),
    ));
  }

  /// Publishes a memory candidate to the bus.
  void publishCandidate(MemoryCandidate candidate) {
    _candidateController.add(candidate);
    KnightLogger.info('[CONTEXT] Published memory candidate: ${candidate.summary}');
  }

  /// Publishes a decision input to the bus.
  void publishDecisionInput(DecisionInput input) {
    _decisionController.add(input);
    KnightLogger.info('[CONTEXT] Published decision input: ${input.type}');
  }

  void _auditFusion(ContextContribution contribution) {
    // Logic to log fusion events in a separate audit table if needed
  }

  Map<String, dynamic> _serializeContext(KnightContext context) {
    // Basic serialization for history (Placeholder)
    return {
      'timestamp': context.timestamp.toIso8601String(),
      'greeting': context.greeting,
      // Add other fields...
    };
  }

  void dispose() {
    _candidateController.close();
    _decisionController.close();
  }
}

final universalContextEngineProvider = Provider<ContextEngine>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  return ContextEngine(db: db);
});
