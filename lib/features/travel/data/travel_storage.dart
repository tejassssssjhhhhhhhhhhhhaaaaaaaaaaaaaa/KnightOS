import '../../../core/storage/local_database.dart';
import '../data/travel_module_state.dart';
import '../domain/planned_trip.dart';
import '../domain/travel_place.dart';

class TravelStorage {
  TravelStorage({LocalDatabase? localDatabase})
    : _database = localDatabase ?? const LocalDatabase();

  final LocalDatabase _database;
  static const String _travelStateFile = 'travel_module_state.json';

  Future<TravelModuleState> loadTravelModuleState() async {
    final decoded = await _database.readJson(_travelStateFile);
    if (decoded == null) {
      return TravelModuleState.initial();
    }

    final rawPlaces = decoded['places'];
    final places = <TravelPlace>[];
    if (rawPlaces is List) {
      for (final item in rawPlaces) {
        if (item is Map<String, Object?>) {
          places.add(TravelPlace.fromJson(item));
        } else if (item is Map) {
          places.add(TravelPlace.fromJson(Map<String, Object?>.from(item)));
        }
      }
    }

    final rawTrips = decoded['plannedTrips'];
    final plannedTrips = <PlannedTrip>[];
    if (rawTrips is List) {
      for (final item in rawTrips) {
        if (item is Map<String, Object?>) {
          plannedTrips.add(PlannedTrip.fromJson(item));
        } else if (item is Map) {
          plannedTrips.add(
            PlannedTrip.fromJson(Map<String, Object?>.from(item)),
          );
        }
      }
    }

    return TravelModuleState(
      places: places,
      plannedTrips: plannedTrips,
      searchQuery: decoded['searchQuery'] is String
          ? decoded['searchQuery'] as String
          : '',
    );
  }

  Future<void> saveTravelModuleState(TravelModuleState state) async {
    final payload = <String, Object?>{
      'places': state.places.map((place) => place.toJson()).toList(),
      'plannedTrips': state.plannedTrips.map((trip) => trip.toJson()).toList(),
      'searchQuery': state.searchQuery,
    };
    await _database.writeJson(
      _travelStateFile,
      Map<String, dynamic>.from(payload),
    );
  }
}
