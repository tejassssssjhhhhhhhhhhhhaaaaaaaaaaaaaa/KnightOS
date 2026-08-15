import 'package:flutter/material.dart';

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

  IconData get icon {
    switch (this) {
      case MemoryDomain.identity: return Icons.person_rounded;
      case MemoryDomain.health: return Icons.favorite_rounded;
      case MemoryDomain.finance: return Icons.account_balance_wallet_rounded;
      case MemoryDomain.travel: return Icons.flight_takeoff_rounded;
      case MemoryDomain.career: return Icons.work_rounded;
      case MemoryDomain.goals: return Icons.track_changes_rounded;
      case MemoryDomain.memories: return Icons.history_rounded;
      case MemoryDomain.documents: return Icons.description_rounded;
      case MemoryDomain.knowledge: return Icons.psychology_rounded;
      default: return Icons.extension_rounded;
    }
  }

  Color get color {
    switch (this) {
      case MemoryDomain.identity: return Colors.white;
      case MemoryDomain.health: return Colors.redAccent;
      case MemoryDomain.finance: return Colors.greenAccent;
      case MemoryDomain.travel: return Colors.blueAccent;
      case MemoryDomain.career: return Colors.indigoAccent;
      case MemoryDomain.goals: return Colors.cyanAccent;
      case MemoryDomain.memories: return Colors.amberAccent;
      case MemoryDomain.documents: return Colors.blueGrey;
      case MemoryDomain.knowledge: return Colors.orangeAccent;
      default: return Colors.white24;
    }
  }

  /// Factory to get domain by ID.
  static MemoryDomain fromId(int id) {
    return MemoryDomain.values.firstWhere(
      (d) => d.id == id,
      orElse: () => MemoryDomain.unknowns,
    );
  }
}
