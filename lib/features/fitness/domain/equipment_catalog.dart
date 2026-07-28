/// Immutable equipment catalog definitions for the fitness module.
class FitnessEquipment {
  const FitnessEquipment({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    this.tags = const <String>[],
  });

  final String id;
  final String name;
  final FitnessEquipmentCategory category;
  final String description;
  final List<String> tags;
}

/// Grouped categories for the equipment catalog.
enum FitnessEquipmentCategory {
  cardio,
  freeWeights,
  machines,
  functional,
  recovery,
  accessories,
}

extension FitnessEquipmentCategoryLabel on FitnessEquipmentCategory {
  String get label {
    switch (this) {
      case FitnessEquipmentCategory.cardio:
        return 'Cardio';
      case FitnessEquipmentCategory.freeWeights:
        return 'Free Weights';
      case FitnessEquipmentCategory.machines:
        return 'Machines';
      case FitnessEquipmentCategory.functional:
        return 'Functional';
      case FitnessEquipmentCategory.recovery:
        return 'Recovery';
      case FitnessEquipmentCategory.accessories:
        return 'Accessories';
    }
  }
}

/// Built-in equipment catalogue used by the fitness module.
class FitnessEquipmentCatalog {
  static const List<FitnessEquipment> items = <FitnessEquipment>[
    FitnessEquipment(
      id: 'treadmill',
      name: 'Treadmill',
      category: FitnessEquipmentCategory.cardio,
      description: 'Cardio machine for walking and running.',
      tags: <String>['cardio', 'running'],
    ),
    FitnessEquipment(
      id: 'exercise-bike',
      name: 'Exercise Bike',
      category: FitnessEquipmentCategory.cardio,
      description: 'Stationary bike for steady cardio.',
      tags: <String>['cardio', 'cycling'],
    ),
    FitnessEquipment(
      id: 'air-bike',
      name: 'Air Bike',
      category: FitnessEquipmentCategory.cardio,
      description: 'Fan-based bike for interval training.',
      tags: <String>['cardio', 'interval'],
    ),
    FitnessEquipment(
      id: 'rowing-machine',
      name: 'Rowing Machine',
      category: FitnessEquipmentCategory.cardio,
      description: 'Full-body cardio equipment.',
      tags: <String>['cardio', 'full-body'],
    ),
    FitnessEquipment(
      id: 'stair-climber',
      name: 'Stair Climber',
      category: FitnessEquipmentCategory.cardio,
      description: 'Vertical cardio burner.',
      tags: <String>['cardio', 'legs'],
    ),
    FitnessEquipment(
      id: 'elliptical',
      name: 'Elliptical',
      category: FitnessEquipmentCategory.cardio,
      description: 'Low-impact cardio machine.',
      tags: <String>['cardio', 'low-impact'],
    ),
    FitnessEquipment(
      id: 'dumbbells',
      name: 'Dumbbells',
      category: FitnessEquipmentCategory.freeWeights,
      description: 'Classic free-weight for strength work.',
      tags: <String>['weights', 'strength'],
    ),
    FitnessEquipment(
      id: 'barbells',
      name: 'Barbells',
      category: FitnessEquipmentCategory.freeWeights,
      description: 'Standard barbell for compound lifts.',
      tags: <String>['weights', 'strength'],
    ),
    FitnessEquipment(
      id: 'ez-bar',
      name: 'EZ Bar',
      category: FitnessEquipmentCategory.freeWeights,
      description: 'Curved bar for easier grip.',
      tags: <String>['weights', 'biceps'],
    ),
    FitnessEquipment(
      id: 'kettlebells',
      name: 'Kettlebells',
      category: FitnessEquipmentCategory.freeWeights,
      description: 'Versatile weights for swings and carries.',
      tags: <String>['weights', 'functional'],
    ),
    FitnessEquipment(
      id: 'weight-plates',
      name: 'Weight Plates',
      category: FitnessEquipmentCategory.freeWeights,
      description: 'Plates for loading bars and machines.',
      tags: <String>['weights', 'plates'],
    ),
    FitnessEquipment(
      id: 'smith-machine',
      name: 'Smith Machine',
      category: FitnessEquipmentCategory.machines,
      description: 'Guided barbell setup for controlled lifts.',
      tags: <String>['machine', 'barbell'],
    ),
    FitnessEquipment(
      id: 'power-rack',
      name: 'Power Rack',
      category: FitnessEquipmentCategory.machines,
      description: 'Rack for squats, presses, and pulls.',
      tags: <String>['rack', 'strength'],
    ),
    FitnessEquipment(
      id: 'squat-rack',
      name: 'Squat Rack',
      category: FitnessEquipmentCategory.machines,
      description: 'Dedicated squat support structure.',
      tags: <String>['rack', 'squat'],
    ),
    FitnessEquipment(
      id: 'bench',
      name: 'Bench',
      category: FitnessEquipmentCategory.machines,
      description: 'Flat or adjustable bench for lifts.',
      tags: <String>['bench', 'press'],
    ),
    FitnessEquipment(
      id: 'resistance-bands',
      name: 'Resistance Bands',
      category: FitnessEquipmentCategory.accessories,
      description: 'Portable bands for mobility and strength.',
      tags: <String>['mobility', 'home'],
    ),
    FitnessEquipment(
      id: 'medicine-balls',
      name: 'Medicine Balls',
      category: FitnessEquipmentCategory.functional,
      description: 'Weighted balls for conditioning.',
      tags: <String>['functional', 'conditioning'],
    ),
    FitnessEquipment(
      id: 'battle-rope',
      name: 'Battle Rope',
      category: FitnessEquipmentCategory.functional,
      description: 'Explosive conditioning tool.',
      tags: <String>['functional', 'conditioning'],
    ),
    FitnessEquipment(
      id: 'pull-up-bar',
      name: 'Pull-up Bar',
      category: FitnessEquipmentCategory.machines,
      description: 'Bar for pull-ups and hanging work.',
      tags: <String>['bodyweight', 'upper-body'],
    ),
    FitnessEquipment(
      id: 'dip-station',
      name: 'Dip Station',
      category: FitnessEquipmentCategory.machines,
      description: 'Parallel bars for dips.',
      tags: <String>['bodyweight', 'upper-body'],
    ),
    FitnessEquipment(
      id: 'trx',
      name: 'TRX',
      category: FitnessEquipmentCategory.functional,
      description: 'Suspension trainer for bodyweight strength.',
      tags: <String>['functional', 'bodyweight'],
    ),
    FitnessEquipment(
      id: 'leg-press',
      name: 'Leg Press',
      category: FitnessEquipmentCategory.machines,
      description: 'Machine-based leg press.',
      tags: <String>['machine', 'legs'],
    ),
    FitnessEquipment(
      id: 'leg-extension',
      name: 'Leg Extension',
      category: FitnessEquipmentCategory.machines,
      description: 'Machine for knee extension.',
      tags: <String>['machine', 'legs'],
    ),
    FitnessEquipment(
      id: 'leg-curl',
      name: 'Leg Curl',
      category: FitnessEquipmentCategory.machines,
      description: 'Machine for hamstring curls.',
      tags: <String>['machine', 'hamstrings'],
    ),
    FitnessEquipment(
      id: 'chest-press',
      name: 'Chest Press',
      category: FitnessEquipmentCategory.machines,
      description: 'Machine-based chest press.',
      tags: <String>['machine', 'chest'],
    ),
    FitnessEquipment(
      id: 'lat-pulldown',
      name: 'Lat Pulldown',
      category: FitnessEquipmentCategory.machines,
      description: 'Machine for upper-back pulling.',
      tags: <String>['machine', 'back'],
    ),
    FitnessEquipment(
      id: 'shoulder-press',
      name: 'Shoulder Press',
      category: FitnessEquipmentCategory.machines,
      description: 'Machine for shoulder pressing.',
      tags: <String>['machine', 'shoulders'],
    ),
    FitnessEquipment(
      id: 'hack-squat',
      name: 'Hack Squat',
      category: FitnessEquipmentCategory.machines,
      description: 'Machine for squat-like loading.',
      tags: <String>['machine', 'legs'],
    ),
    FitnessEquipment(
      id: 'hip-thrust-machine',
      name: 'Hip Thrust Machine',
      category: FitnessEquipmentCategory.machines,
      description: 'Machine for hip thrusts.',
      tags: <String>['machine', 'glutes'],
    ),
    FitnessEquipment(
      id: 'ab-machine',
      name: 'Ab Machine',
      category: FitnessEquipmentCategory.machines,
      description: 'Machine for abdominal training.',
      tags: <String>['machine', 'core'],
    ),
    FitnessEquipment(
      id: 'calf-raise-machine',
      name: 'Calf Raise Machine',
      category: FitnessEquipmentCategory.machines,
      description: 'Machine for calf raises.',
      tags: <String>['machine', 'calves'],
    ),
    FitnessEquipment(
      id: 'foam-roller',
      name: 'Foam Roller',
      category: FitnessEquipmentCategory.recovery,
      description: 'Recovery tool for tissue work.',
      tags: <String>['recovery', 'mobility'],
    ),
    FitnessEquipment(
      id: 'massage-ball',
      name: 'Massage Ball',
      category: FitnessEquipmentCategory.recovery,
      description: 'Recovery tool for mobility.',
      tags: <String>['recovery', 'mobility'],
    ),
    FitnessEquipment(
      id: 'stretch-band',
      name: 'Stretch Band',
      category: FitnessEquipmentCategory.recovery,
      description: 'Mobility and recovery support.',
      tags: <String>['recovery', 'mobility'],
    ),
  ];
}
