class JournalEntry {
  const JournalEntry({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.tags = const <String>[],
    this.mood,
    this.permission = 'conversation_only',
    this.source = 'text',
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final List<String> tags;
  final String? mood;
  final String permission;
  final String source;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'createdAt': createdAt.toIso8601String(),
      'tags': tags,
      'mood': mood,
      'permission': permission,
      'source': source,
    };
  }

  factory JournalEntry.fromJson(Map<String, Object?> json) {
    return JournalEntry(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Journal entry',
      body: json['body'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      tags:
          (json['tags'] as List?)?.whereType<String>().toList() ??
          const <String>[],
      mood: json['mood'] as String?,
      permission: json['permission'] as String? ?? 'conversation_only',
      source: json['source'] as String? ?? 'text',
    );
  }
}
