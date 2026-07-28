import '../../../core/platform/storage/knight_entity.dart';

class WorkSession extends KnightEntity {
  WorkSession({
    super.id,
    super.createdAt,
    super.updatedAt,
    super.version,
    super.isDeleted,
    super.deletedAt,
    super.syncStatus,
    super.deviceId,
    required this.workDate,
    required this.startTime,
    required this.endTime,
    required this.shiftType,
    required this.questionsCompleted,
    required this.callsHandled,
    required this.chatsHandled,
    required this.breakDuration,
    required this.focusRating,
    required this.stressRating,
    required this.energyRating,
    required this.notes,
    required this.totalHours,
    required this.productiveHours,
    required this.callsPercentage,
    required this.chatsPercentage,
    required this.questionsPerHour,
    required this.weeklyAverage,
    required this.monthlyAverage,
  });

  final String workDate;
  final String startTime;
  final String endTime;
  final String shiftType;
  final int questionsCompleted;
  final int callsHandled;
  final int chatsHandled;
  final int breakDuration;
  final int focusRating;
  final int stressRating;
  final int energyRating;
  final String notes;
  final double totalHours;
  final double productiveHours;
  final double callsPercentage;
  final double chatsPercentage;
  final double questionsPerHour;
  final double weeklyAverage;
  final double monthlyAverage;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'version': version,
      'isDeleted': isDeleted,
      'deletedAt': deletedAt?.toIso8601String(),
      'syncStatus': syncStatus,
      'deviceId': deviceId,
      'workDate': workDate,
      'startTime': startTime,
      'endTime': endTime,
      'shiftType': shiftType,
      'questionsCompleted': questionsCompleted,
      'callsHandled': callsHandled,
      'chatsHandled': chatsHandled,
      'breakDuration': breakDuration,
      'focusRating': focusRating,
      'stressRating': stressRating,
      'energyRating': energyRating,
      'notes': notes,
      'totalHours': totalHours,
      'productiveHours': productiveHours,
      'callsPercentage': callsPercentage,
      'chatsPercentage': chatsPercentage,
      'questionsPerHour': questionsPerHour,
      'weeklyAverage': weeklyAverage,
      'monthlyAverage': monthlyAverage,
    };
  }

  factory WorkSession.fromJson(Map<String, Object?> json) {
    return WorkSession(
      id: json['id'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      version: json['version'] as int? ?? 1,
      isDeleted: json['isDeleted'] as bool? ?? false,
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'] as String)
          : null,
      syncStatus: json['syncStatus'] as String? ?? 'pending',
      deviceId: json['deviceId'] as String?,
      workDate: json['workDate'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      shiftType: json['shiftType'] as String? ?? '',
      questionsCompleted: json['questionsCompleted'] as int? ?? 0,
      callsHandled: json['callsHandled'] as int? ?? 0,
      chatsHandled: json['chatsHandled'] as int? ?? 0,
      breakDuration: json['breakDuration'] as int? ?? 0,
      focusRating: json['focusRating'] as int? ?? 0,
      stressRating: json['stressRating'] as int? ?? 0,
      energyRating: json['energyRating'] as int? ?? 0,
      notes: json['notes'] as String? ?? '',
      totalHours: (json['totalHours'] as num?)?.toDouble() ?? 0.0,
      productiveHours: (json['productiveHours'] as num?)?.toDouble() ?? 0.0,
      callsPercentage: (json['callsPercentage'] as num?)?.toDouble() ?? 0.0,
      chatsPercentage: (json['chatsPercentage'] as num?)?.toDouble() ?? 0.0,
      questionsPerHour: (json['questionsPerHour'] as num?)?.toDouble() ?? 0.0,
      weeklyAverage: (json['weeklyAverage'] as num?)?.toDouble() ?? 0.0,
      monthlyAverage: (json['monthlyAverage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  WorkSession copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    bool? isDeleted,
    DateTime? deletedAt,
    String? syncStatus,
    String? deviceId,
    String? workDate,
    String? startTime,
    String? endTime,
    String? shiftType,
    int? questionsCompleted,
    int? callsHandled,
    int? chatsHandled,
    int? breakDuration,
    int? focusRating,
    int? stressRating,
    int? energyRating,
    String? notes,
    double? totalHours,
    double? productiveHours,
    double? callsPercentage,
    double? chatsPercentage,
    double? questionsPerHour,
    double? weeklyAverage,
    double? monthlyAverage,
  }) {
    return WorkSession(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      deviceId: deviceId ?? this.deviceId,
      workDate: workDate ?? this.workDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      shiftType: shiftType ?? this.shiftType,
      questionsCompleted: questionsCompleted ?? this.questionsCompleted,
      callsHandled: callsHandled ?? this.callsHandled,
      chatsHandled: chatsHandled ?? this.chatsHandled,
      breakDuration: breakDuration ?? this.breakDuration,
      focusRating: focusRating ?? this.focusRating,
      stressRating: stressRating ?? this.stressRating,
      energyRating: energyRating ?? this.energyRating,
      notes: notes ?? this.notes,
      totalHours: totalHours ?? this.totalHours,
      productiveHours: productiveHours ?? this.productiveHours,
      callsPercentage: callsPercentage ?? this.callsPercentage,
      chatsPercentage: chatsPercentage ?? this.chatsPercentage,
      questionsPerHour: questionsPerHour ?? this.questionsPerHour,
      weeklyAverage: weeklyAverage ?? this.weeklyAverage,
      monthlyAverage: monthlyAverage ?? this.monthlyAverage,
    );
  }
}
