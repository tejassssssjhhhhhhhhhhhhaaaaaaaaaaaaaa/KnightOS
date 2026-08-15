import 'dart:async';
import 'package:collection/collection.dart';
import '../domain/planning_models.dart';
import '../domain/workflow_models.dart';
import '../domain/mission_models.dart';
import '../intelligence_bus.dart';

import '../domain/knight_memory.dart';
import '../domain/memory_category.dart';
import '../domain/memory_domain.dart';
import 'memory_engine.dart';
import '../domain/intelligence_events.dart';

import '../domain/reasoning_models.dart';
import '../domain/approval_models.dart';
import '../knight_context_models.dart';
import '../services/world_service.dart';
import '../services/voice_service.dart';
import '../../world/adapters/calendar_connector.dart';
import '../../world/adapters/email_connector.dart';
import '../domain/world_models.dart';
import 'reasoning_engine.dart';

/// The execution layer of KnightOS that automates multi-step plans.
class AutonomousEngine {
  AutonomousEngine({
    required this.bus,
    required this.memoryEngine,
    required this.reasoningEngine,
    required this.getContext,
    this.worldService,
    this.voiceService,
  }) {
    _listenForRemoteCompletion();
  }

  final IntelligenceBus bus;
  final MemoryEngine memoryEngine;
  final ReasoningEngine reasoningEngine;
  final Future<KnightContext> Function() getContext;
  final WorldService? worldService;
  final VoiceService? voiceService;

  final Map<String, WorkflowState> _activeWorkflows = {};
  final Map<String, ReasoningResult> _failureReasonings = {};
  final Map<String, ApprovalRequest> _pendingApprovals = {};
  final Map<String, Completer<ApprovalStatus>> _approvalCompleters = {};
  final Map<String, Completer<void>> _remoteTaskCompleters = {};

  /// Requests manual approval for a specific action.
  Future<ApprovalStatus> requestApproval({
    required String id,
    required String actionDescription,
    required String reasoning,
    ApprovalRisk riskLevel = ApprovalRisk.medium,
  }) async {
    final request = ApprovalRequest(
      id: id,
      planId: 'system',
      taskId: id,
      actionDescription: actionDescription,
      reasoning: reasoning,
      riskLevel: riskLevel,
      timestamp: DateTime.now(),
    );

    _pendingApprovals[request.id] = request;
    final completer = Completer<ApprovalStatus>();
    _approvalCompleters[request.id] = completer;

    bus.emit(ApprovalRequestedEvent(request: request));

    final result = await completer.future;
    
    _pendingApprovals.remove(request.id);
    _approvalCompleters.remove(request.id);

    return result;
  }

  /// Starts execution of a plan.
  Future<void> executePlan(KnightPlan plan) async {
    final firstTask = plan.tasks.firstOrNull;
    if (firstTask == null) return;
    
    _updateState(plan.id, WorkflowStatus.running, firstTask.id, 0.0);

    for (var i = 0; i < plan.tasks.length; i++) {
      final task = plan.tasks[i];
      final progress = (i / plan.tasks.length);
      
      _updateState(plan.id, WorkflowStatus.running, task.id, progress);

      // 1. Human-in-the-loop check
      if (task.isSensitive) {
        _updateState(plan.id, WorkflowStatus.awaitingApproval, task.id, progress);
        
        final request = ApprovalRequest(
          id: 'approval-${plan.id}-${task.id}',
          planId: plan.id,
          taskId: task.id,
          actionDescription: task.title,
          reasoning: task.description ?? 'This action requires verification.',
          riskLevel: task.priority == MissionPriority.critical ? ApprovalRisk.critical : ApprovalRisk.medium,
          timestamp: DateTime.now(),
        );

        _pendingApprovals[request.id] = request;
        final completer = Completer<ApprovalStatus>();
        _approvalCompleters[request.id] = completer;

        bus.emit(ApprovalRequestedEvent(request: request));

        // Proactive Voice Alert (Sprint 7)
        if (voiceService != null && request.riskLevel == ApprovalRisk.critical) {
          final ctx = await getContext();
          voiceService!.speak('Attention required for a critical mission step.', context: ctx);
        }

        final result = await completer.future;
        
        _pendingApprovals.remove(request.id);
        _approvalCompleters.remove(request.id);

        if (result == ApprovalStatus.denied) {
          _updateState(plan.id, WorkflowStatus.failed, task.id, progress, error: 'Action denied by user.');
          return;
        }
        
        // Resume execution
        _updateState(plan.id, WorkflowStatus.running, task.id, progress);
      }

      // 2. Task Execution (Simulated)
      try {
        await _executeTask(task, plan.id);
      } catch (e) {
        // --- Sprint 4.4 Self-Healing Logic ---
        
        // A. Check for fallbacks
        final fallbackId = task.fallbackTaskIds.firstOrNull;
        if (fallbackId != null) {
           final fallbackTask = plan.tasks.where((t) => t.id == fallbackId).firstOrNull;
           
           if (fallbackTask != null) {
              bus.emit(WorkflowHealingEvent(planId: plan.id, failedTaskId: task.id, fallbackTaskId: fallbackId));
              try {
                await _executeTask(fallbackTask, plan.id);
                continue; // Fallback succeeded, proceed to next task in original plan
              } catch (_) {
                // Fallback also failed, proceed to reasoning
              }
           }
        }

        // B. Repair Reasoning
        final context = await getContext();
        final reasoning = await reasoningEngine.suggestRepairPlan(
          planId: plan.id,
          taskId: task.id,
          error: e.toString(),
          context: context,
        );
        
        _failureReasonings[plan.id] = reasoning;
        
        _updateState(
          plan.id, 
          WorkflowStatus.failed, 
          task.id, 
          progress, 
          error: reasoning.summary,
        );
        return;
      }
    }

    _updateState(plan.id, WorkflowStatus.succeeded, null, 1.0);
  }

  Future<void> _executeTask(KnightTask task, String planId) async {
    // 1. Remote Delegation check
    if (task.targetDeviceId != null && task.targetDeviceId != 'local') {
      final completer = Completer<void>();
      _remoteTaskCompleters['$planId-${task.id}'] = completer;
      
      bus.emit(RemoteTaskExecutionEvent(
        taskId: task.id, 
        deviceId: task.targetDeviceId!, 
        planId: planId,
      ));

      // Wait for remote completion event (Simulated)
      await completer.future;
      return;
    }

    // 2. Real Connector Execution (Sprint 4.5)
    if (worldService != null) {
      if (task.title.toLowerCase().contains('schedule') || 
          task.title.toLowerCase().contains('calendar')) {
        final connector = worldService!.engine.registeredConnectors
            .whereType<GoogleCalendarConnector>()
            .firstOrNull;
        
        if (connector != null) {
          await connector.client.createEvent(CalendarEvent(
            id: 'auto-${DateTime.now().millisecondsSinceEpoch}',
            title: task.title,
            startTime: DateTime.now().add(const Duration(hours: 1)),
            endTime: DateTime.now().add(const Duration(hours: 2)),
            description: task.description,
          ));
        }
      }

      if (task.title.toLowerCase().contains('email') || 
          task.title.toLowerCase().contains('send')) {
        final connector = worldService!.engine.registeredConnectors
            .whereType<GoogleEmailConnector>()
            .firstOrNull;
        
        if (connector != null) {
          await connector.client.sendDraft('draft-${task.id}');
        }
      }
    }

    // 3. Simulated automation latency
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (task.title.contains('FAIL')) {
      throw Exception('Simulation Failure: task requested to fail.');
    }
    
    // Future: Call TaskAutomationManager
  }

  void _listenForRemoteCompletion() {
    bus.events.where((e) => e is RemoteTaskCompletedEvent).listen((e) {
      final event = e as RemoteTaskCompletedEvent;
      final key = '${event.planId}-${event.taskId}';
      final completer = _remoteTaskCompleters.remove(key);
      
      if (completer != null && !completer.isCompleted) {
        if (event.error != null) {
          completer.completeError(event.error!);
        } else {
          completer.complete();
        }
      }
    });
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
    
    // Broadcast event (Sprint 4.1)
    bus.emit(WorkflowUpdatedEvent(state: state));

    // Record to Ledger
    _recordToLedger(state);
  }

  Future<void> _recordToLedger(WorkflowState state) async {
    final memory = KnightMemory.create(
      memoryId: 'ledger-${state.planId}-${DateTime.now().millisecondsSinceEpoch}',
      category: BookCategory.history,
      domain: MemoryDomain.memories,
      source: MemorySource.aiGenerated,
      content: {
        'planId': state.planId,
        'status': state.status.name,
        'taskId': state.currentTaskId,
        'progress': state.progress,
        'error': state.errorMessage,
      },
      summary: 'Workflow Event: ${state.status.name} (${state.planId})',
      importance: 0.1,
    );
    await memoryEngine.save(memory);
  }

  WorkflowState? getWorkflowState(String planId) => _activeWorkflows[planId];

  ReasoningResult? getFailureReasoning(String planId) => _failureReasonings[planId];

  void resolveApproval(String requestId, ApprovalStatus status) {
    final completer = _approvalCompleters[requestId];
    if (completer != null && !completer.isCompleted) {
      completer.complete(status);
      bus.emit(ApprovalResolvedEvent(requestId: requestId, status: status));
    }
  }

  List<ApprovalRequest> get pendingApprovals => _pendingApprovals.values.toList();
}
