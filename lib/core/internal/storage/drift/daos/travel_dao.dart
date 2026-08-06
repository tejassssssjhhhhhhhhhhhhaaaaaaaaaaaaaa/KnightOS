import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/travel_foundation.dart';

part 'travel_dao.g.dart';

@DriftAccessor(tables: [
  TripTable,
  TravelBookingTable,
  TravelEvidenceVaultTable,
  TravelMetricsTable,
  TravelGeographicEnrichmentTable,
])
class TravelDao extends DatabaseAccessor<KnightDatabase> with _$TravelDaoMixin {
  TravelDao(super.db);

  Future<List<TripData>> getAllTrips() => select(tripTable).get();

  Future<List<TravelBookingData>> getAllBookings() => select(travelBookingTable).get();

  Future<TravelBookingData?> getBooking(String id) =>
      (select(travelBookingTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<TravelBookingData>> getBookingsForTrip(String tripId) =>
      (select(travelBookingTable)..where((t) => t.tripId.equals(tripId))).get();

  Future<int> insertTrip(TripTableCompanion trip) =>
      into(tripTable).insert(trip);

  Future<void> upsertTrip(TripTableCompanion trip) =>
      into(tripTable).insertOnConflictUpdate(trip);

  Future<void> upsertBooking(TravelBookingTableCompanion booking) =>
      into(travelBookingTable).insertOnConflictUpdate(booking);

  // Evidence Vault
  Future<void> insertEvidence(TravelEvidenceVaultTableCompanion evidence) =>
      into(travelEvidenceVaultTable).insert(evidence);

  Future<List<TravelEvidenceVaultData>> getAllEvidence() =>
      select(travelEvidenceVaultTable).get();

  // Metrics
  Future<void> upsertMetric(TravelMetricsTableCompanion metric) =>
      into(travelMetricsTable).insertOnConflictUpdate(metric);

  Future<TravelMetricsData?> getMetric(String key) =>
      (select(travelMetricsTable)..where((t) => t.metricKey.equals(key))).getSingleOrNull();

  Future<List<TravelMetricsData>> getAllMetrics() =>
      select(travelMetricsTable).get();

  // Geo Enrichment
  Future<void> upsertGeoEnrichment(TravelGeographicEnrichmentTableCompanion geo) =>
      into(travelGeographicEnrichmentTable).insertOnConflictUpdate(geo);

  Future<List<TravelGeographicEnrichmentData>> getAllGeoEnrichment() =>
      select(travelGeographicEnrichmentTable).get();

  Future<TravelGeographicEnrichmentData?> getGeoInfo(String placeId) =>
      (select(travelGeographicEnrichmentTable)..where((t) => t.placeId.equals(placeId)))
          .getSingleOrNull();

  Future<TravelGeographicEnrichmentData?> getGeoEnrichment(String placeId) =>
      (select(travelGeographicEnrichmentTable)..where((t) => t.placeId.equals(placeId)))
          .getSingleOrNull();
}
