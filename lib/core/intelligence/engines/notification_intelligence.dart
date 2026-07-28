import '../../world/domain/world_models.dart';

/// Decisions about interruptions and notifications.
class NotificationIntelligence {
  const NotificationIntelligence();

  /// Evaluates whether an interruption is permitted given the current world context.
  InterruptionDecision shouldInterrupt({
    required WorldContext context,
    required double urgency,
    required String reason,
  }) {
    // 1. Silent Hours
    if (context.currentActivity == 'Sleeping') {
      return urgency > 0.9
          ? InterruptionDecision.allow(channel: 'critical_alert')
          : InterruptionDecision.silence(reason: 'User is likely sleeping.');
    }

    // 2. Focused Work
    if (context.currentActivity == 'Working' && urgency < 0.7) {
      return InterruptionDecision.batch(reason: 'User is focused on work.');
    }

    return InterruptionDecision.allow();
  }
}

/// Represents the result of an interruption evaluation.
class InterruptionDecision {
  const InterruptionDecision({
    required this.allowed,
    this.channel = 'default',
    this.reason,
    this.delayUntil,
  });

  final bool allowed;
  final String channel;
  final String? reason;
  final DateTime? delayUntil;

  factory InterruptionDecision.allow({String channel = 'default'}) =>
      InterruptionDecision(allowed: true, channel: channel);

  factory InterruptionDecision.silence({String? reason}) =>
      InterruptionDecision(allowed: false, reason: reason);

  factory InterruptionDecision.batch({String? reason}) =>
      InterruptionDecision(allowed: false, reason: reason);
}
