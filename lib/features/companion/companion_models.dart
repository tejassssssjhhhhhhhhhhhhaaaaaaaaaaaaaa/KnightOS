class CompanionEntry {
  const CompanionEntry({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.kind = 'reflection',
    this.permission = 'conversation_only',
    this.tags = const <String>[],
    this.source = 'chat',
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final String kind;
  final String permission;
  final List<String> tags;
  final String source;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'createdAt': createdAt.toIso8601String(),
      'kind': kind,
      'permission': permission,
      'tags': tags,
      'source': source,
    };
  }

  factory CompanionEntry.fromJson(Map<String, Object?> json) {
    return CompanionEntry(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Entry',
      body: json['body'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      kind: json['kind'] as String? ?? 'reflection',
      permission: json['permission'] as String? ?? 'conversation_only',
      tags:
          (json['tags'] as List?)?.whereType<String>().toList() ??
          const <String>[],
      source: json['source'] as String? ?? 'chat',
    );
  }
}
