/// Represents the 30 foundational domains of the Knight Knowledge Base ontology.
enum MemoryDomain {
  identity(1, "Identity"),
  biography(2, "Biography"),
  family(3, "Family"),
  relationships(4, "Relationships"),
  education(5, "Education"),
  career(6, "Career"),
  skills(7, "Skills"),
  health(8, "Health"),
  mentalModels(9, "Mental Models"),
  personality(10, "Personality"),
  habits(11, "Habits"),
  dailyRoutine(12, "Daily Routine"),
  finance(13, "Finance"),
  assets(14, "Assets"),
  devices(15, "Devices"),
  preferences(16, "Preferences"),
  entertainment(17, "Entertainment"),
  travel(18, "Travel"),
  projects(19, "Projects"),
  goals(20, "Goals"),
  lifeValues(21, "Values"),
  beliefs(22, "Beliefs"),
  decisionHistory(23, "Decision History"),
  achievements(24, "Achievements"),
  failures(25, "Failures"),
  lessonsLearned(26, "Lessons Learned"),
  memories(27, "Memories"),
  documents(28, "Documents"),
  knowledge(29, "Knowledge"),
  unknowns(30, "Unknowns");

  const MemoryDomain(this.id, this.label);

  /// The numerical ID from the Master Memory Specification.
  final int id;

  /// The human-readable label of the domain.
  final String label;

  /// Factory to get domain by ID.
  static MemoryDomain fromId(int id) {
    return MemoryDomain.values.firstWhere((d) => d.id == id);
  }
}
