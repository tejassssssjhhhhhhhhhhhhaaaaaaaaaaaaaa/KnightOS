class LearningGoal {
  const LearningGoal({
    required this.id,
    required this.title,
    required this.reason,
    required this.createdAt,
    this.targetCompletion,
    this.dailyTime,
    this.level = 'beginner',
    this.style = 'guided',
    this.permission = 'conversation_only',
  });

  final String id;
  final String title;
  final String reason;
  final DateTime createdAt;
  final String? targetCompletion;
  final String? dailyTime;
  final String level;
  final String style;
  final String permission;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'reason': reason,
      'createdAt': createdAt.toIso8601String(),
      'targetCompletion': targetCompletion,
      'dailyTime': dailyTime,
      'level': level,
      'style': style,
      'permission': permission,
    };
  }

  factory LearningGoal.fromJson(Map<String, Object?> json) {
    return LearningGoal(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Learning goal',
      reason: json['reason'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      targetCompletion: json['targetCompletion'] as String?,
      dailyTime: json['dailyTime'] as String?,
      level: json['level'] as String? ?? 'beginner',
      style: json['style'] as String? ?? 'guided',
      permission: json['permission'] as String? ?? 'conversation_only',
    );
  }
}
