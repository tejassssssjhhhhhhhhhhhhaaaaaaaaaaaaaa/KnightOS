import 'package:equatable/equatable.dart';

/// Base class for all KnightOS platform events.
abstract class KnightEvent extends Equatable {
  const KnightEvent({required this.timestamp});
  final DateTime timestamp;

  @override
  List<Object?> get props => [timestamp];
}

/// Events related to the Integration Hub and Connectors.
abstract class IntegrationEvent extends KnightEvent {
  const IntegrationEvent({
    required this.connectorId,
    required super.timestamp,
  });
  final String connectorId;

  @override
  List<Object?> get props => [connectorId, ...super.props];
}

class ConnectorConnected extends IntegrationEvent {
  const ConnectorConnected({required super.connectorId, required super.timestamp});
}

class ConnectorDisconnected extends IntegrationEvent {
  const ConnectorDisconnected({required super.connectorId, required super.timestamp});
}

class SyncStarted extends IntegrationEvent {
  const SyncStarted({required super.connectorId, required super.timestamp});
}

class SyncCompleted extends IntegrationEvent {
  const SyncCompleted({
    required super.connectorId,
    required super.timestamp,
    required this.itemsProcessed,
  });
  final int itemsProcessed;

  @override
  List<Object?> get props => [itemsProcessed, ...super.props];
}

class SyncFailed extends IntegrationEvent {
  const SyncFailed({
    required super.connectorId,
    required super.timestamp,
    required this.error,
    required this.category,
  });
  final String error;
  final String category;

  @override
  List<Object?> get props => [error, category, ...super.props];
}

class EvidenceImported extends IntegrationEvent {
  const EvidenceImported({
    required super.connectorId,
    required super.timestamp,
    required this.evidenceId,
    required this.type,
  });
  final String evidenceId;
  final String type;

  @override
  List<Object?> get props => [evidenceId, type, ...super.props];
}

class EvidenceVerified extends IntegrationEvent {
  const EvidenceVerified({
    required super.connectorId,
    required super.timestamp,
    required this.evidenceId,
  });
  final String evidenceId;

  @override
  List<Object?> get props => [evidenceId, ...super.props];
}

/// Granular pipeline stage events for real-time visualization.
abstract class PipelineStageEvent extends IntegrationEvent {
  const PipelineStageEvent({
    required super.connectorId,
    required super.timestamp,
    required this.stage,
    required this.humanExplanation,
    required this.technicalDetail,
    this.resourceId,
    this.metadata,
  });

  final String stage;
  final String humanExplanation;
  final String technicalDetail;
  final String? resourceId;
  final Map<String, dynamic>? metadata;

  @override
  List<Object?> get props => [stage, humanExplanation, technicalDetail, resourceId, metadata, ...super.props];
}

class PipelineStageStarted extends PipelineStageEvent {
  const PipelineStageStarted({
    required super.connectorId,
    required super.timestamp,
    required super.stage,
    required super.humanExplanation,
    required super.technicalDetail,
    super.resourceId,
    super.metadata,
  });
}

class PipelineStageCompleted extends PipelineStageEvent {
  const PipelineStageCompleted({
    required super.connectorId,
    required super.timestamp,
    required super.stage,
    required super.humanExplanation,
    required super.technicalDetail,
    super.resourceId,
    super.metadata,
  });
}

class PipelineStageFailed extends PipelineStageEvent {
  const PipelineStageFailed({
    required super.connectorId,
    required super.timestamp,
    required super.stage,
    required super.humanExplanation,
    required super.technicalDetail,
    required this.error,
    super.resourceId,
    super.metadata,
  });
  final String error;

  @override
  List<Object?> get props => [error, ...super.props];
}
