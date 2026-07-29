import '../engines/autonomous_engine.dart';
import '../domain/planning_models.dart';
import '../domain/workflow_models.dart';

/// The public API for autonomous task execution.
class AutonomousService {
  const AutonomousService({required this.engine});

  final AutonomousEngine engine;

  /// Approves and starts a generated plan.
  Future<void> launchPlan(KnightPlan plan) => engine.executePlan(plan);

  /// Retrieves the real-time status of a running plan.
  WorkflowState? getStatus(String planId) => engine.getWorkflowState(planId);
}
