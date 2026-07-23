/// Immutable planned trip model for the travel module.
class PlannedTrip {
  const PlannedTrip({
    required this.id,
    required this.destination,
    required this.tentativeMonthYear,
    required this.estimatedBudget,
    required this.notes,
  });

  final String id;
  final String destination;
  final String tentativeMonthYear;
  final String estimatedBudget;
  final String notes;

  PlannedTrip copyWith({
    String? id,
    String? destination,
    String? tentativeMonthYear,
    String? estimatedBudget,
    String? notes,
  }) {
    return PlannedTrip(
      id: id ?? this.id,
      destination: destination ?? this.destination,
      tentativeMonthYear: tentativeMonthYear ?? this.tentativeMonthYear,
      estimatedBudget: estimatedBudget ?? this.estimatedBudget,
      notes: notes ?? this.notes,
    );
  }

  factory PlannedTrip.fromJson(Map<String, Object?> json) {
    return PlannedTrip(
      id: json['id'] as String? ?? '',
      destination: json['destination'] as String? ?? '',
      tentativeMonthYear: json['tentativeMonthYear'] as String? ?? '',
      estimatedBudget: json['estimatedBudget'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'destination': destination,
      'tentativeMonthYear': tentativeMonthYear,
      'estimatedBudget': estimatedBudget,
      'notes': notes,
    };
  }
}
