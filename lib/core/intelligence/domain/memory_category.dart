import 'package:flutter/material.dart';

/// Represents the 11 Knowledge Books (Categories) in the Knight Knowledge Base.
enum BookCategory {
  identity(1, "Identity (The Soul)"),
  career(2, "Career & Mission (The Impact)"),
  health(3, "Health & Vitality (The Vessel)"),
  finance(4, "Finance & Resources (The Fuel)"),
  social(5, "Social & Relationships (The Tribe)"),
  philosophy(6, "Philosophy & Ethics (The Compass)"),
  skills(7, "Skills & Expertise (The Toolbelt)"),
  history(8, "History & Archives (The Ledger)"),
  preferences(9, "Preferences & Tastes (The Style)"),
  ambitions(10, "Ambitions & Future (The Horizon)"),
  unknown(11, "The Unknown & Mystery (The Void)");

  const BookCategory(this.id, this.label);

  /// The Roman numeral or integer ID of the book.
  final int id;

  /// The full title of the book.
  final String label;

  Color get color {
    switch (this) {
      case BookCategory.identity: return const Color(0xFFFFFFFF);
      case BookCategory.career: return const Color(0xFF6366F1);
      case BookCategory.health: return const Color(0xFFF43F5E);
      case BookCategory.finance: return const Color(0xFF10B981);
      case BookCategory.social: return const Color(0xFFD946EF);
      case BookCategory.philosophy: return const Color(0xFFF59E0B);
      case BookCategory.skills: return const Color(0xFF22D3EE);
      case BookCategory.history: return const Color(0xFF94A3B8);
      case BookCategory.preferences: return const Color(0xFF0EA5E9);
      case BookCategory.ambitions: return const Color(0xFF0EA5E9);
      case BookCategory.unknown: return const Color(0xFF1E293B);
    }
  }

  /// Factory to get category by ID.
  static BookCategory fromId(int id) {
    return BookCategory.values.firstWhere((c) => c.id == id);
  }
}

/// Alias for backward compatibility
typedef MemoryCategory = BookCategory;

/// The high-level type of memory.
enum MemoryType {
  /// Permanent information that rarely changes (Who I am).
  identity,

  /// Temporal information that happens at a point in time (What happened).
  event,
}

/// The origin of a specific memory.
enum MemorySource { manual, imported, aiGenerated, sensor }
