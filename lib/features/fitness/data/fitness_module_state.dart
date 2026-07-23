import '../../../core/engine/feature_interfaces.dart';
import '../domain/gym_profile.dart';

/// Immutable persisted state for the fitness module.
class FitnessModuleState {
  const FitnessModuleState({
    required this.gymProfile,
    required this.availableEquipmentIds,
    required this.searchQuery,
  });

  final GymProfile gymProfile;
  final List<String> availableEquipmentIds;
  final String searchQuery;

  factory FitnessModuleState.initial() => const FitnessModuleState(
        gymProfile: GymProfile(name: '', type: GymProfileType.home),
        availableEquipmentIds: <String>[],
        searchQuery: '',
      );

  FitnessModuleState copyWith({
    GymProfile? gymProfile,
    List<String>? availableEquipmentIds,
    String? searchQuery,
  }) {
    return FitnessModuleState(
      gymProfile: gymProfile ?? this.gymProfile,
      availableEquipmentIds: availableEquipmentIds ?? this.availableEquipmentIds,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Engine-facing adapter for the fitness module.
class FitnessModuleRuntimeState {
  const FitnessModuleRuntimeState({
    required this.metadata,
    required this.capabilities,
    required this.configuration,
    required this.state,
  });

  final KnightModuleMetadata metadata;
  final List<KnightModuleCapability> capabilities;
  final KnightModuleConfiguration configuration;
  final KnightModuleState state;
}
