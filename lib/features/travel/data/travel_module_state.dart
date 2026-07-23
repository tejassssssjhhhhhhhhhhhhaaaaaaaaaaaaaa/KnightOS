import '../domain/planned_trip.dart';
import '../domain/travel_place.dart';

/// Immutable persisted state for the travel module.
class TravelModuleState {
  const TravelModuleState({
    required this.places,
    required this.plannedTrips,
    required this.searchQuery,
  });

  final List<TravelPlace> places;
  final List<PlannedTrip> plannedTrips;
  final String searchQuery;

  factory TravelModuleState.initial() => const TravelModuleState(
        places: <TravelPlace>[],
        plannedTrips: <PlannedTrip>[],
        searchQuery: '',
      );

  TravelModuleState copyWith({
    List<TravelPlace>? places,
    List<PlannedTrip>? plannedTrips,
    String? searchQuery,
  }) {
    return TravelModuleState(
      places: places ?? this.places,
      plannedTrips: plannedTrips ?? this.plannedTrips,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
