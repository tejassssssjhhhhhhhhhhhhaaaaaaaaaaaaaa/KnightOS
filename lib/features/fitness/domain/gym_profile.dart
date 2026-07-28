/// Immutable gym profile model for the fitness module.
class GymProfile {
  const GymProfile({required this.name, required this.type, this.notes = ''});

  final String name;
  final GymProfileType type;
  final String notes;

  factory GymProfile.empty() =>
      const GymProfile(name: '', type: GymProfileType.home);

  factory GymProfile.fromJson(Map<String, Object?> json) {
    final typeValue = json['type'] as String?;
    return GymProfile(
      name: json['name'] as String? ?? '',
      type: typeValue == 'commercial'
          ? GymProfileType.commercial
          : GymProfileType.home,
      notes: json['notes'] as String? ?? '',
    );
  }

  Map<String, Object> toJson() {
    return <String, Object>{'name': name, 'type': type.name, 'notes': notes};
  }
}

/// Supported gym profile types.
enum GymProfileType { home, commercial }

extension GymProfileTypeLabel on GymProfileType {
  String get label {
    switch (this) {
      case GymProfileType.home:
        return 'Home';
      case GymProfileType.commercial:
        return 'Commercial';
    }
  }
}
