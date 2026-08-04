import '../../../internal/storage/drift/knight_database.dart';
import 'package:drift/drift.dart';

/// Geographic Intelligence Engine.
class TravelGeoEngine {
  final TravelDao travelDao;

  TravelGeoEngine({required this.travelDao});

  /// Enriches a location with administrative metadata.
  Future<TravelGeographicEnrichmentData> enrich(String placeName, {double? lat, double? lng}) async {
    final cached = await travelDao.getGeoEnrichment(placeName);
    if (cached != null) return cached;

    final enriched = TravelGeographicEnrichmentTableCompanion.insert(
      id: 'geo_$placeName',
      placeId: placeName,
      country: 'Unknown',
      state: const Value(null),
      city: const Value(null),
      timezone: const Value('UTC'),
      administrativeHierarchy: const Value('[]'),
      latitude: Value(lat),
      longitude: Value(lng),
    );
    
    await travelDao.upsertGeoEnrichment(enriched);
    return (await travelDao.getGeoEnrichment(placeName))!;
  }
}
