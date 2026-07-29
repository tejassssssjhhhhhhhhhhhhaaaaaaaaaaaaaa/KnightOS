import 'dart:async';
import '../domain/notification_models.dart';
import '../domain/reasoning_models.dart';
import '../domain/planning_models.dart';
import '../knight_context_models.dart';
import '../intelligence_bus.dart';

/// The engine responsible for proactive alert generation and contextual filtering.
class NotificationEngine {
  NotificationEngine({required this.bus});

  final IntelligenceBus bus;
  final List<KnightNotification> _history = [];

  /// Processes reasoning results to determine if a notification is required.
  List<KnightNotification> evaluateReasoning(
    ReasoningResult reasoning, 
    KnightContext context
  ) {
    final List<KnightNotification> generated = [];

    // 1. Mute Logic (Deep Work)
    final isMuted = context.currentActivity == 'Working' && 
                    context.energyLevel == 'High'; // Assuming focused state

    // 2. Map high-priority recommendations
    for (final rec in reasoning.recommendations) {
      final priority = _mapPriority(rec.priority);
      
      // Filter: Only notify if not muted OR if critical
      if (!isMuted || priority == NotificationPriority.critical) {
        if (priority == NotificationPriority.high || priority == NotificationPriority.critical) {
          generated.add(KnightNotification(
            id: 'notif-${rec.id}',
            title: rec.title,
            body: rec.description,
            category: _mapCategory(rec.category),
            priority: priority,
            timestamp: DateTime.now(),
            actionLabel: 'Open',
          ));
        }
      }
    }

    _history.addAll(generated);
    return generated;
  }

  NotificationPriority _mapPriority(dynamic p) {
    // In Sprint 1.8, we use a simple mapping from recommendation priorities
    return NotificationPriority.high; 
  }

  NotificationCategory _mapCategory(dynamic c) {
    return NotificationCategory.system;
  }

  List<KnightNotification> get history => List.unmodifiable(_history);
}
