import '../../platform/engine/recommendation_models.dart';
import '../domain/notification_models.dart';
import '../domain/reasoning_models.dart';
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
    final currentActivity = context.workSummary.productivityPlaceholder.contains('Focus') 
        ? 'Working' 
        : 'Active';
    final isMuted = currentActivity == 'Working';

    // 2. Map high-priority recommendations
    for (final rec in reasoning.recommendations) {
      final priority = _mapPriority(rec.priority);
      
      // Filter: Only notify if not muted OR if critical
      if (!isMuted || priority == NotificationPriority.critical) {
        if (priority.index >= NotificationPriority.high.index) {
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

  NotificationPriority _mapPriority(KnightRecommendationPriority p) {
    switch (p) {
      case KnightRecommendationPriority.critical: return NotificationPriority.critical;
      case KnightRecommendationPriority.high: return NotificationPriority.high;
      case KnightRecommendationPriority.medium: return NotificationPriority.medium;
      case KnightRecommendationPriority.low: return NotificationPriority.low;
    }
  }

  NotificationCategory _mapCategory(KnightRecommendationCategory c) {
    switch (c) {
      case KnightRecommendationCategory.health: return NotificationCategory.health;
      case KnightRecommendationCategory.finance: return NotificationCategory.finance;
      case KnightRecommendationCategory.work: return NotificationCategory.mission;
      case KnightRecommendationCategory.sleep: return NotificationCategory.health;
      case KnightRecommendationCategory.fitness: return NotificationCategory.health;
      default: return NotificationCategory.system;
    }
  }

  List<KnightNotification> get history => List.unmodifiable(_history);
}
