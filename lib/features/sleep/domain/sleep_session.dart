class SleepSession {
  const SleepSession({
    required this.id,
    required this.sleepDate,
    required this.bedTime,
    required this.wakeTime,
    required this.sleepQuality,
    required this.wakeUps,
    required this.napDuration,
    required this.moodAfterWaking,
    required this.energyLevel,
    required this.notes,
    required this.sleepDuration,
  });

  final String id;
  final String sleepDate;
  final String bedTime;
  final String wakeTime;
  final int sleepQuality;
  final int wakeUps;
  final double napDuration;
  final String moodAfterWaking;
  final int energyLevel;
  final String notes;
  final double sleepDuration;

  double get calculatedSleepDuration {
    if (sleepDuration > 0) {
      return sleepDuration;
    }

    final parsedBedTime = _parseTime(bedTime);
    final parsedWakeTime = _parseTime(wakeTime);
    if (parsedBedTime == null || parsedWakeTime == null) {
      return 0;
    }

    var hours = parsedWakeTime.difference(parsedBedTime).inMinutes / 60;
    if (hours < 0) {
      hours += 24;
    }

    return hours.clamp(0, 16).toDouble();
  }

  DateTime? _parseTime(String input) {
    final parts = input.trim().split(':');
    if (parts.length != 2) {
      return null;
    }
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) {
      return null;
    }
    return DateTime(2000, 1, 1, hour, minute);
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'sleepDate': sleepDate,
      'bedTime': bedTime,
      'wakeTime': wakeTime,
      'sleepQuality': sleepQuality,
      'wakeUps': wakeUps,
      'napDuration': napDuration,
      'moodAfterWaking': moodAfterWaking,
      'energyLevel': energyLevel,
      'notes': notes,
      'sleepDuration': sleepDuration,
    };
  }

  factory SleepSession.fromJson(Map<String, Object?> json) {
    return SleepSession(
      id: json['id'] as String? ?? '',
      sleepDate: json['sleepDate'] as String? ?? '',
      bedTime: json['bedTime'] as String? ?? '',
      wakeTime: json['wakeTime'] as String? ?? '',
      sleepQuality: json['sleepQuality'] as int? ?? 0,
      wakeUps: json['wakeUps'] as int? ?? 0,
      napDuration: (json['napDuration'] as num?)?.toDouble() ?? 0.0,
      moodAfterWaking: json['moodAfterWaking'] as String? ?? '',
      energyLevel: json['energyLevel'] as int? ?? 0,
      notes: json['notes'] as String? ?? '',
      sleepDuration: (json['sleepDuration'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
