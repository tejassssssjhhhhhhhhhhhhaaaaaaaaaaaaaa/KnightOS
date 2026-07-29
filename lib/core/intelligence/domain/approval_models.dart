import 'package:flutter/foundation.dart';

enum ApprovalStatus {
  pending,
  approved,
  denied,
}

enum ApprovalRisk {
  low,
  medium,
  high,
  critical,
}

@immutable
class ApprovalRequest {
  const ApprovalRequest({
    required this.id,
    required this.planId,
    required this.taskId,
    required this.actionDescription,
    required this.reasoning,
    required this.riskLevel,
    this.status = ApprovalStatus.pending,
    required this.timestamp,
  });

  final String id;
  final String planId;
  final String taskId;
  final String actionDescription;
  final String reasoning;
  final ApprovalRisk riskLevel;
  final ApprovalStatus status;
  final DateTime timestamp;

  ApprovalRequest copyWith({
    ApprovalStatus? status,
  }) {
    return ApprovalRequest(
      id: id,
      planId: planId,
      taskId: taskId,
      actionDescription: actionDescription,
      reasoning: reasoning,
      riskLevel: riskLevel,
      status: status ?? this.status,
      timestamp: timestamp,
    );
  }
}
