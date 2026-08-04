import 'package:equatable/equatable.dart';

enum CalendarHealthStatus {
  healthy,
  degraded,
  failing,
  disconnected,
  unknown,
}

class CalendarSyncState extends Equatable {
  const CalendarSyncState({
    required this.providerId,
    this.lastSyncAt,
    this.nextSyncAt,
    this.syncToken,
    this.importedCount = 0,
    this.updatedCount = 0,
    this.deletedCount = 0,
    this.failedCount = 0,
    this.lastError,
    this.healthStatus = CalendarHealthStatus.unknown,
  });

  final String providerId;
  final DateTime? lastSyncAt;
  final DateTime? nextSyncAt;
  final String? syncToken;
  final int importedCount;
  final int updatedCount;
  final int deletedCount;
  final int failedCount;
  final String? lastError;
  final CalendarHealthStatus healthStatus;

  @override
  List<Object?> get props => [
        providerId,
        lastSyncAt,
        nextSyncAt,
        syncToken,
        importedCount,
        updatedCount,
        deletedCount,
        failedCount,
        lastError,
        healthStatus,
      ];

  CalendarSyncState copyWith({
    DateTime? lastSyncAt,
    DateTime? nextSyncAt,
    String? syncToken,
    int? importedCount,
    int? updatedCount,
    int? deletedCount,
    int? failedCount,
    String? lastError,
    CalendarHealthStatus? healthStatus,
  }) {
    return CalendarSyncState(
      providerId: providerId,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      nextSyncAt: nextSyncAt ?? this.nextSyncAt,
      syncToken: syncToken ?? this.syncToken,
      importedCount: importedCount ?? this.importedCount,
      updatedCount: updatedCount ?? this.updatedCount,
      deletedCount: deletedCount ?? this.deletedCount,
      failedCount: failedCount ?? this.failedCount,
      lastError: lastError ?? this.lastError,
      healthStatus: healthStatus ?? this.healthStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lastSyncAt': lastSyncAt?.toIso8601String(),
      'nextSyncAt': nextSyncAt?.toIso8601String(),
      'syncToken': syncToken,
      'importedCount': importedCount,
      'updatedCount': updatedCount,
      'deletedCount': deletedCount,
      'failedCount': failedCount,
      'lastError': lastError,
      'healthStatus': healthStatus.name,
    };
  }

  factory CalendarSyncState.fromJson(String providerId, Map<String, dynamic> json) {
    return CalendarSyncState(
      providerId: providerId,
      lastSyncAt: json['lastSyncAt'] != null ? DateTime.parse(json['lastSyncAt']) : null,
      nextSyncAt: json['nextSyncAt'] != null ? DateTime.parse(json['nextSyncAt']) : null,
      syncToken: json['syncToken'],
      importedCount: json['importedCount'] ?? 0,
      updatedCount: json['updatedCount'] ?? 0,
      deletedCount: json['deletedCount'] ?? 0,
      failedCount: json['failedCount'] ?? 0,
      lastError: json['lastError'],
      healthStatus: CalendarHealthStatus.values.firstWhere(
        (e) => e.name == json['healthStatus'],
        orElse: () => CalendarHealthStatus.unknown,
      ),
    );
  }
}
