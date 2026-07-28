class KnowledgeFact {
  const KnowledgeFact({
    required this.id,
    required this.category,
    required this.value,
    this.createdAt,
  });

  final String id;
  final String category;
  final String value;
  final DateTime? createdAt;
}

class PersonalKnowledgeBase {
  const PersonalKnowledgeBase({
    required this.facts,
    required this.preferences,
    required this.goals,
    required this.habits,
  });

  final List<KnowledgeFact> facts;
  final List<KnowledgeFact> preferences;
  final List<KnowledgeFact> goals;
  final List<KnowledgeFact> habits;
}
