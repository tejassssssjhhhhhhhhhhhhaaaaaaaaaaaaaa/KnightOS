import '../../../internal/storage/drift/knight_database.dart';
import 'package:drift/drift.dart';

/// Background Intelligence Engine for Travel Metrics.
class TravelMetricsEngine {
  final TravelDao travelDao;

  TravelMetricsEngine({required this.travelDao});

  /// Recalculates all lifetime travel metrics.
  Future<void> recalculateAll() async {
    final trips = await travelDao.getAllTrips();
    await _updateMetric('total_trips', trips.length.toDouble());
    
    final bookings = await travelDao.getBookingsForTrip('all'); // Placeholder
    final flights = bookings.where((b) => b.type == 'flight').length;
    await _updateMetric('total_flights', flights.toDouble());
  }

  Future<void> _updateMetric(String key, double value) async {
    await travelDao.upsertMetric(
      TravelMetricsTableCompanion.insert(
        id: 'metric_$key',
        metricKey: key,
        metricValue: value,
        lastUpdated: DateTime.now(),
      ),
    );
  }
}
