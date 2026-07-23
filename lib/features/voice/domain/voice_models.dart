class VoiceSession {
  const VoiceSession({
    required this.id,
    required this.transcript,
    required this.createdAt,
    this.isEdited = false,
    this.status = 'captured',
  });

  final String id;
  final String transcript;
  final DateTime createdAt;
  final bool isEdited;
  final String status;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'transcript': transcript,
      'createdAt': createdAt.toIso8601String(),
      'isEdited': isEdited,
      'status': status,
    };
  }

  factory VoiceSession.fromJson(Map<String, Object?> json) {
    return VoiceSession(
      id: json['id'] as String? ?? '',
      transcript: json['transcript'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      isEdited: json['isEdited'] as bool? ?? false,
      status: json['status'] as String? ?? 'captured',
    );
  }
}

class VoiceMemory {
  const VoiceMemory({
    required this.id,
    required this.transcript,
    required this.createdAt,
    this.source = 'voice',
    this.summary = 'Stored locally for later review.',
  });

  final String id;
  final String transcript;
  final DateTime createdAt;
  final String source;
  final String summary;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'transcript': transcript,
      'createdAt': createdAt.toIso8601String(),
      'source': source,
      'summary': summary,
    };
  }

  factory VoiceMemory.fromJson(Map<String, Object?> json) {
    return VoiceMemory(
      id: json['id'] as String? ?? '',
      transcript: json['transcript'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      source: json['source'] as String? ?? 'voice',
      summary: json['summary'] as String? ?? 'Stored locally for later review.',
    );
  }
}
