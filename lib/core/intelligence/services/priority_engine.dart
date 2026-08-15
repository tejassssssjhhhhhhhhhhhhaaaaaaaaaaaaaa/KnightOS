import '../knight_context_models.dart';
import '../../design_system/knight_tokens.dart';
import '../../design_system/design_constants.dart';
import 'package:flutter/material.dart';

enum PriorityType { urgent, suggestion, info }

class PriorityItem {
  final String title;
  final String description;
  final PriorityType type;
  final IconData icon;
  final Color color;
  final VoidCallback? onAction;

  const PriorityItem({
    required this.title,
    required this.description,
    required this.type,
    required this.icon,
    required this.color,
    this.onAction,
  });
}

class PriorityEngine {
  const PriorityEngine();

  List<PriorityItem> calculatePriorities(KnightContext context) {
    final List<PriorityItem> items = [];
    final accent = KnightTokens.accent(context.period);

    // Relaxation Mode Filter
    if (context.isRelaxationMode) {
      // In Relaxation mode, we only surface critical/safety items.
      items.add(const PriorityItem(
        title: 'System Shift',
        description: 'Knight OS is performing background optimization.',
        type: PriorityType.info,
        icon: Icons.nightlight_round,
        color: Colors.blueAccent,
      ));
    }

    // 0. Reasoning Engine Insights (The "Brain's" direct output)
    if (context.reasoning != null) {
      for (final warning in context.reasoning!.warnings) {
        items.add(PriorityItem(
          title: 'System Warning',
          description: warning,
          type: PriorityType.urgent,
          icon: Icons.warning_amber_rounded,
          color: DesignColors.error,
        ));
      }
      for (final insight in context.reasoning!.insights) {
        items.add(PriorityItem(
          title: insight.title,
          description: insight.description,
          type: PriorityType.info,
          icon: Icons.psychology_rounded,
          color: DesignColors.accentBlue,
        ));
      }
    }

    // 1. Critical Tasks (Overdue)
    if (!context.isRelaxationMode) {
      final overdueTasks = context.planning?.dailyPlan.tasks.where((t) => t.isOverdue) ?? [];
      for (final task in overdueTasks) {
        items.add(PriorityItem(
          title: 'Action Required',
          description: 'Task "${task.title}" is overdue.',
          type: PriorityType.urgent,
          icon: Icons.priority_high_rounded,
          color: accent,
        ));
      }
    }

    // 2. Upcoming Events (Meetings/Flights)
    if (!context.isRelaxationMode) {
      final upcomingEvents = context.recentTimelineEvents.where((e) {
        final now = DateTime.now();
        return e.startTime.isAfter(now) && e.startTime.isBefore(now.add(const Duration(hours: 4)));
      });
      for (final event in upcomingEvents) {
        items.add(PriorityItem(
          title: 'Coming Up',
          description: '${event.title} starts soon.',
          type: PriorityType.urgent,
          icon: Icons.event_available_rounded,
          color: accent,
        ));
      }
    }

    // 3. Travel Awareness
    for (final trip in context.activeTrips) {
      items.add(PriorityItem(
        title: 'Travel',
        description: 'Active trip: ${trip.title}',
        type: PriorityType.info,
        icon: Icons.flight_takeoff_rounded,
        color: DesignColors.travel,
      ));
    }

    // 4. Health Reminders
    if (!context.isRelaxationMode) {
      if (context.steps < 1000 && DateTime.now().hour > 10) {
        items.add(PriorityItem(
          title: 'Move Momentum',
          description: 'You\'ve only taken ${context.steps} steps. Let\'s stretch.',
          type: PriorityType.suggestion,
          icon: Icons.directions_run_rounded,
          color: DesignColors.health,
        ));
      }
    }

    // 5. Financial Alerts
    final largeExpenses = context.recentTransactions.where((t) => t.type == 'expense' && t.amount > 5000);
    if (largeExpenses.isNotEmpty) {
      items.add(PriorityItem(
        title: 'Finance Review',
        description: 'Large expenses detected. Review your budget?',
        type: PriorityType.suggestion,
        icon: Icons.account_balance_wallet_rounded,
        color: DesignColors.finance,
      ));
    }

    // 6. Career/Reminders
    if (context.pendingReminders > 0) {
      items.add(PriorityItem(
        title: 'Attention',
        description: 'You have ${context.pendingReminders} pending reminders.',
        type: PriorityType.suggestion,
        icon: Icons.notification_important_rounded,
        color: accent,
      ));
    }

    // Default if empty
    if (items.isEmpty) {
      items.add(PriorityItem(
        title: 'System Nominal',
        description: 'All goals are on track. Enjoy your ${context.greeting.split(',').first}.',
        type: PriorityType.info,
        icon: Icons.check_circle_outline_rounded,
        color: Colors.white24,
      ));
    }

    return items;
  }
}
