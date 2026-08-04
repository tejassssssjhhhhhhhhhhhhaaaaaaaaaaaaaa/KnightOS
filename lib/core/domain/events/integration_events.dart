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
