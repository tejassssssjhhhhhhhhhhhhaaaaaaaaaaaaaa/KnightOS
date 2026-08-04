import 'package:equatable/equatable.dart';

enum ErrorCategory {
  none,
  authentication,
  network,
  rateLimit,
  providerDown,
  normalization,
  internal,
}

/// Operational metrics and status for a connector.
class ConnectorHealth extends Equatable {
  const ConnectorHealth({
    this.lastSyncAt,
    this.nextSyncAt,
    this.successRate = 1.0,
    this.failureCount = 0,
    this.averageDurationMs = 0,
    this.lastError,
    this.lastErrorCategory = ErrorCategory.none,
    required this.apiStatus,
    required this.version,
  });

  final DateTime? lastSyncAt;
  final DateTime? nextSyncAt;
  final double successRate;
  final int failureCount;
  final int averageDurationMs;
  final String? lastError;
  final ErrorCategory lastErrorCategory;
  final String apiStatus; // e.g., 'operational', 'degraded'
  final String version;

  @override
  List<Object?> get props => [
        lastSyncAt,
        nextSyncAt,
        successRate,
        failureCount,
        averageDurationMs,
        lastError,
        lastErrorCategory,
        apiStatus,
        version,
      ];

  ConnectorHealth copyWith({
    DateTime? lastSyncAt,
    DateTime? nextSyncAt,
    double? successRate,
    int? failureCount,
    int? averageDurationMs,
    String? lastError,
    ErrorCategory? lastErrorCategory,
    String? apiStatus,
    String? version,
  }) {
    return ConnectorHealth(
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      nextSyncAt: nextSyncAt ?? this.nextSyncAt,
      successRate: successRate ?? this.successRate,
      failureCount: failureCount ?? this.failureCount,
      averageDurationMs: averageDurationMs ?? this.averageDurationMs,
      lastError: lastError ?? this.lastError,
      lastErrorCategory: lastErrorCategory ?? this.lastErrorCategory,
      apiStatus: apiStatus ?? this.apiStatus,
      version: version ?? this.version,
    );
  }
}
