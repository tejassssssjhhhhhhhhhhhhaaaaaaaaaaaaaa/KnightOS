import 'dart:async';
import '../domain/planning_models.dart';
import 'autonomous_engine.dart';

/// Advanced execution manager for non-linear and conditional plans.
class WorkflowOrchestrator {
  WorkflowOrchestrator({required this.engine});

  final AutonomousEngine engine;

  /// Executes a plan with support for fallback branches.
  Future<void> run(KnightPlan plan) async {
    final Map<String, KnightTask> taskMap = {for (var t in plan.tasks) t.id: t};
    final Set<String> completed = {};

    for (var task in plan.tasks) {
      if (completed.contains(task.id)) continue;

      // 1. Wait for dependencies
      for (var depId in task.dependencyIds) {
        // Simple linear assumption for this sprint foundation
        if (!completed.contains(depId)) {
          // Dependency missing, logic to handle out-of-order execution here
        }
      }

      // 2. Execute with Fallback Support
      try {
        await engine.executePlan(KnightPlan(
          id: '${plan.id}-${task.id}',
          title: task.title,
          goalId: plan.goalId,
          tasks: [task],
          status: plan.status,
          createdAt: plan.createdAt,
        ));
        completed.add(task.id);
      } catch (e) {
        // 3. Trigger Fallbacks
        for (var fallbackId in task.fallbackTaskIds) {
          final fallback = taskMap[fallbackId];
          if (fallback != null) {
            await run(KnightPlan(
              id: '${plan.id}-fallback-${fallback.id}',
              title: fallback.title,
              goalId: plan.goalId,
              tasks: [fallback],
              status: plan.status,
              createdAt: plan.createdAt,
            ));
          }
        }
      }
    }
  }
}
