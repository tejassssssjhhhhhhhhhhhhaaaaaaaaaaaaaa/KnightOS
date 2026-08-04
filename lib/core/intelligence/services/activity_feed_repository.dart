import 'package:drift/drift.dart';
import '../domain/activity_feed_models.dart';
import '../../internal/storage/drift/knight_database.dart';
import 'package:flutter/material.dart';
import '../../design_system/design_constants.dart';

class ActivityFeedRepository {
  ActivityFeedRepository({required this.db});
  final KnightDatabase db;

  Future<List<ActivityItem>> getGlobalFeed({int limit = 30}) async {
    final List<ActivityItem> items = [];

    // 1. Transactions
    try {
      final txs = await db.financialDao.getTransactions(limit: limit);
      for (final tx in txs) {
        items.add(ActivityItem(
          type: ActivityType.transaction,
          id: tx.id,
          title: tx.description,
          subtitle: '${tx.type == 'income' ? '+' : '-'}₹${tx.amount.toInt()}',
          timestamp: tx.transactionDate,
          icon: Icons.account_balance_wallet_rounded,
          color: DesignColors.finance,
          originalData: tx,
        ));
      }
    } catch (_) {}

    // 2. Timeline
    try {
      final events = await db.timelineDao.getRecentEvents(limit: limit);
      for (final e in events) {
        items.add(ActivityItem(
          type: ActivityType.timeline,
          id: e.id,
          title: e.title,
          subtitle: e.type.toUpperCase(),
          timestamp: e.startTime,
          icon: e.type == 'visit' ? Icons.location_on_rounded : Icons.directions_run_rounded,
          color: DesignColors.accentPurple,
          originalData: e,
        ));
      }
    } catch (_) {}

    // 3. Imports
    try {
      final imports = await db.importDao.getAllImports();
      for (final imp in imports.take(limit)) {
        items.add(ActivityItem(
          type: ActivityType.import,
          id: imp.id,
          title: 'Intelligence Indexed',
          subtitle: imp.fileName,
          timestamp: imp.createdAt,
          icon: Icons.auto_awesome_rounded,
          color: DesignColors.accentBlue,
          originalData: imp,
        ));
      }
    } catch (_) {}

    // 4. Tasks
    try {
      final tasks = await db.missionDao.getTodaysTasks();
      for (final t in tasks.take(limit)) {
        items.add(ActivityItem(
          type: ActivityType.task,
          id: t.id,
          title: t.title,
          subtitle: t.isCompleted ? 'Completed' : 'Priority: ${t.priority}',
          timestamp: t.updatedAt,
          icon: t.isCompleted ? Icons.check_circle_rounded : Icons.circle_outlined,
          color: DesignColors.focus,
          originalData: t,
        ));
      }
    } catch (_) {}

    // 5. Health Sessions (Workout)
    try {
      final workouts = await (db.select(db.workoutSessionTable)
            ..orderBy([(t) => OrderingTerm.desc(t.startTime)])
            ..limit(limit))
          .get();
      for (final w in workouts) {
         items.add(ActivityItem(
          type: ActivityType.health,
          id: w.id,
          title: '${w.workoutType} Session',
          subtitle: '${w.durationMinutes.toInt()} minutes',
          timestamp: w.startTime,
          icon: Icons.fitness_center_rounded,
          color: DesignColors.health,
          originalData: w,
        ));
      }
    } catch (_) {}

    // 6. Health Sessions (Sleep)
    try {
      final sleep = await (db.select(db.sleepSessionTable)
            ..orderBy([(t) => OrderingTerm.desc(t.wakeTime)])
            ..limit(limit))
          .get();
      for (final s in sleep) {
         items.add(ActivityItem(
          type: ActivityType.health,
          id: s.id,
          title: 'Sleep Record',
          subtitle: 'Quality: ${s.sleepQuality}/10',
          timestamp: s.wakeTime,
          icon: Icons.bedtime_rounded,
          color: DesignColors.accentPurple,
          originalData: s,
        ));
      }
    } catch (_) {}

    // Sort chronologically (descending)
    items.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return items.take(limit).toList();
  }
}
