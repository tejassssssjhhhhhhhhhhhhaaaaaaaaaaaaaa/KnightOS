import 'dart:async';
import '../domain/planning_models.dart';
import '../domain/workflow_models.dart';
import '../intelligence_bus.dart';
import '../domain/intelligence_events.dart';

/// The execution layer of KnightOS that automates multi-step plans.
class AutonomousEngine {
  AutonomousEngine({required this.bus});

  final IntelligenceBus bus;
  final Map<String, WorkflowState> _activeWorkflows = {};

  /// Starts execution of a plan.
  Future<void> executePlan(KnightPlan plan) async {
    _updateState(plan.id, WorkflowStatus.running, plan.tasks.first.id, 0.0);

    for (var i = 0; i < plan.tasks.length; i++) {
      final task = plan.tasks[i];
      final progress = (i / plan.tasks.length);
      
      _updateState(plan.id, WorkflowStatus.running, task.id, progress);

      // 1. Human-in-the-loop check
      if (task.isSensitive) {
        _updateState(plan.id, WorkflowStatus.awaitingApproval, task.id, progress);
        // In a real app, we would wait for an event. Here we simulate approval.
        await Future.delayed(const Duration(milliseconds: 500)); 
      }

      // 2. Task Execution (Simulated)
      try {
        await _executeTask(task);
      } catch (e) {
        _updateState(plan.id, WorkflowStatus.failed, task.id, progress, error: e.toString());
        return;
      }
    }

    _updateState(plan.id, WorkflowStatus.succeeded, null, 1.0);
  }

  Future<void> _executeTask(KnightTask task) async {
    // Simulated automation latency
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Future: Call TaskAutomationManager
  }

  void _updateState(
    String planId, 
    WorkflowStatus status, 
    String? taskId, 
    double progress, 
    {String? error}
  ) {
    final state = WorkflowState(
      planId: planId,
      status: status,
      currentTaskId: taskId,
      progress: progress,
      errorMessage: error,
    );
    _activeWorkflows[planId] = state;
    
    // Future: Emit workflow event to bus
  }

  WorkflowState? getWorkflowState(String planId) => _activeWorkflows[planId];
}
