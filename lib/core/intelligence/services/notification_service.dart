import '../engines/notification_engine.dart';
import '../domain/notification_models.dart';
import '../domain/reasoning_models.dart';
import '../knight_context_models.dart';

/// Public API for KnightOS proactive alerts.
class NotificationService {
  NotificationService({required this.engine});

  final NotificationEngine engine;
  final List<KnightNotification> _activeNotifications = [];

  /// Processes recent intelligence to surface new notifications.
  List<KnightNotification> processSituationalAlerts({
    required ReasoningResult reasoning,
    required KnightContext context,
  }) {
    final news = engine.evaluateReasoning(reasoning, context);
    _activeNotifications.addAll(news);
    
    // Future: Trigger OS-level notification bridge
    return news;
  }

  List<KnightNotification> getActive() => List.unmodifiable(_activeNotifications);

  void dismiss(String id) {
    _activeNotifications.removeWhere((n) => n.id == id);
  }
}
