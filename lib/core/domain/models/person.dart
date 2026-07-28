class Person {
  const Person({
    required this.id,
    required this.displayName,
    this.email,
    this.phone,
    this.role,
    this.avatarUrl,
    this.tags = const [],
    this.metadata = const {},
  });

  final String id;
  final String displayName;
  final String? email;
  final String? phone;
  final String? role;
  final String? avatarUrl;
  final List<String> tags;
  final Map<String, dynamic> metadata;
}
