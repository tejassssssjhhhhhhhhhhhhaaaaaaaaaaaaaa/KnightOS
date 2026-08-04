import '../../intelligence/domain/intelligence_events.dart';
import '../../intelligence/domain/knight_memory.dart';
import '../../intelligence/engines/memory_engine.dart';
import '../engines/trigger_engine.dart';
import '../engines/action_engine.dart';
import 'package:knight_os/core/internal/utils/knight_logger.dart';

/// Monitors transactions and triggers mission reviews if large expenses occur.
class ProactiveBudgetWorkflow {
  ProactiveBudgetWorkflow({
    required this.triggers,
    required this.actions,
    required this.memoryEngine,
  });

  final TriggerEngine triggers;
  final ActionEngine actions;
  final MemoryEngine memoryEngine;

  void init() {
    triggers.on<DataChangedEvent>(_handleDataChanged);
  }

  Future<void> _handleDataChanged(DataChangedEvent event) async {
    for (final memory in event.memories) {
      if (memory.tags.contains('transaction')) {
        final amount = memory.content['amount'] as double? ?? 0.0;
        if (amount > 1000.0) {
           KnightLogger.info('[WORKFLOW] Large transaction detected: $amount. Triggering budget review.');
           await _triggerBudgetReview(memory);
        }
      }
    }
  }

  Future<void> _triggerBudgetReview(KnightMemory txMemory) async {
    // Proactive step: Suggest a mission update
    await actions.execute('notify_user', {
      'title': 'Budget Insight',
      'message': 'A large transaction was detected. Would you like to review your current mission budget?',
    });
  }
}
