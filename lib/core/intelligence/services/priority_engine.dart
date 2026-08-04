import '../knight_context_models.dart';
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

    // 1. Critical Tasks (Overdue)
    final overdueTasks = context.planning?.dailyPlan.tasks.where((t) => t.isOverdue) ?? [];
    for (final task in overdueTasks) {
      items.add(PriorityItem(
        title: 'Action Required',
        description: 'Task "${task.title}" is overdue.',
        type: PriorityType.urgent,
        icon: Icons.priority_high_rounded,
        color: Colors.redAccent,
      ));
    }

    // 2. Upcoming Events (Meetings/Flights)
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
        color: Colors.blueAccent,
      ));
    }

    // 3. Health Reminders
    if (context.steps < 1000 && DateTime.now().hour > 10) {
      items.add(PriorityItem(
        title: 'Move Momentum',
        description: 'You\'ve only taken ${context.steps} steps. Let\'s stretch.',
        type: PriorityType.suggestion,
        icon: Icons.directions_run_rounded,
        color: Colors.orangeAccent,
      ));
    }

    // 4. Financial Alerts
    final largeExpenses = context.recentTransactions.where((t) => t.type == 'expense' && t.amount > 5000);
    if (largeExpenses.isNotEmpty) {
      items.add(PriorityItem(
        title: 'Finance Review',
        description: 'Large expenses detected. Review your budget?',
        type: PriorityType.suggestion,
        icon: Icons.account_balance_wallet_rounded,
        color: Colors.greenAccent,
      ));
    }

    // Default if empty
    if (items.isEmpty) {
      items.add(PriorityItem(
        title: 'System Nominal',
        description: 'All goals are on track. Enjoy your ${context.greeting.split(',').first.toLowerCase()}.',
        type: PriorityType.info,
        icon: Icons.check_circle_outline_rounded,
        color: Colors.white24,
      ));
    }

    return items;
  }
}
