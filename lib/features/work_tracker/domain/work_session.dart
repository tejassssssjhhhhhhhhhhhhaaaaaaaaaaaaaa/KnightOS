class WorkSession {
  const WorkSession({
    required this.id,
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

  final String id;
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

  Map<String, Object> toJson() {
    return {
      'id': id,
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
      id: json['id'] as String? ?? '',
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
}
