import 'package:flutter/foundation.dart';

/// Execution status for a multi-step autonomous workflow.
enum WorkflowStatus {
  queued,
  running,
  awaitingApproval,
  paused,
  succeeded,
  failed,
}

/// A snapshot of an active workflow's execution state.
@immutable
class WorkflowState {
  const WorkflowStatusState({
    required this.planId,
    required this.status,
    required this.currentTaskId,
    this.errorMessage,
    this.progress = 0.0,
  });

  final String planId;
  final WorkflowStatus status;
  final String? currentTaskId;
  final String? errorMessage;
  final double progress;
}
