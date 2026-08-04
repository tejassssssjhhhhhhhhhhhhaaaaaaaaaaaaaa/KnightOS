import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../providers/database_provider.dart';
import '../domain/reminder_models.dart';
import '../knight_context_provider.dart';

class HealthReminderService {
  HealthReminderService({required this.db, required this.ref});
  final KnightDatabase db;
  final Ref ref;

  Future<List<UnifiedReminder>> generateProactiveReminders() async {
    final context = await ref.read(currentContextNotifierProvider.future);
    final reminders = <UnifiedReminder>[];

    // 1. Water Reminder
    if (context.waterIntake < 1.0) {
      reminders.add(UnifiedReminder(
        id: 'reminder-water-${DateTime.now().millisecondsSinceEpoch}',
        type: ReminderType.water,
        title: 'Hydration Target',
        description: 'You have only logged ${context.waterIntake}L today. Target is 2.5L.',
        scheduledAt: DateTime.now(),
        priority: ReminderPriority.medium,
        metadata: {
          'evidence': 'water_intake_metric',
          'reason': 'Low hydration affects focus scores.',
          'confidence': 0.95,
          'context': 'Active working state',
        },
      ));
    }

    // 3. Workout Reminder
    if (context.activeMinutes < 15) {
      reminders.add(UnifiedReminder(
        id: 'reminder-workout-${DateTime.now().millisecondsSinceEpoch}',
        type: ReminderType.workout,
        title: 'Move your body',
        description: 'You\'ve only had ${context.activeMinutes} active minutes today.',
        scheduledAt: DateTime.now(),
        priority: ReminderPriority.medium,
        metadata: {
          'evidence': 'active_minutes_metric',
          'reason': 'Consistent movement improves recovery scores.',
          'confidence': 0.88,
          'context': 'Sedentary state detected',
        },
      ));
    }

    // 4. Sleep Reminder
    final now = DateTime.now();
    if (now.hour >= 22) {
      reminders.add(UnifiedReminder(
        id: 'reminder-sleep-${DateTime.now().millisecondsSinceEpoch}',
        type: ReminderType.sleep,
        title: 'Wind down',
        description: 'It\'s past 10 PM. Prepare for optimal sleep quality.',
        scheduledAt: DateTime.now(),
        priority: ReminderPriority.medium,
        metadata: {
          'evidence': 'time_based',
          'reason': 'Consistent bedtimes are key to circadian health.',
          'confidence': 1.0,
          'context': 'Late night detected',
        },
      ));
    }

    return reminders;
  }
}

final healthReminderServiceProvider = Provider<HealthReminderService>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  return HealthReminderService(db: db, ref: ref);
});
