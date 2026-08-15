import '../engines/autonomous_engine.dart';
import '../domain/planning_models.dart';
import '../domain/workflow_models.dart';
import '../domain/approval_models.dart';
import '../intelligence_bus.dart';
import '../domain/intelligence_events.dart';

/// The public API for autonomous task execution.
class AutonomousService {
  const AutonomousService({required this.engine, required this.bus});

  final AutonomousEngine engine;
  final IntelligenceBus bus;

  /// Approves and starts a generated plan.
  Future<void> launchPlan(KnightPlan plan) => engine.executePlan(plan);

  /// Retrieves the real-time status of a running plan.
  WorkflowState? getStatus(String planId) => engine.getWorkflowState(planId);

  /// Returns the reasoning for a failed plan.
  dynamic getFailureReasoning(String planId) => engine.getFailureReasoning(planId);

  /// Stream of all active workflow updates.
  Stream<List<WorkflowState>> watchActiveExecutions() {
    return bus.events
        .where((e) => e is WorkflowUpdatedEvent)
        .map((_) => _getActiveStates());
  }

  /// Stream of pending approvals.
  Stream<List<ApprovalRequest>> watchPendingApprovals() {
    return bus.events
        .where((e) => e is ApprovalRequestedEvent || e is ApprovalResolvedEvent)
        .map((_) => engine.pendingApprovals);
  }

  /// Proactively requests approval for a system-level action.
  Future<ApprovalStatus> requestSystemAction({
    required String id,
    required String action,
    required String reasoning,
    ApprovalRisk risk = ApprovalRisk.medium,
  }) {
    return engine.requestApproval(
      id: id,
      actionDescription: action,
      reasoning: reasoning,
      riskLevel: risk,
    );
  }

  List<WorkflowState> _getActiveStates() {
    // This is a simplified fetch from the engine's internal map
    // In a real app, the engine would provide a proper stream.
    return []; // Future: implement proper tracking
  }
}
