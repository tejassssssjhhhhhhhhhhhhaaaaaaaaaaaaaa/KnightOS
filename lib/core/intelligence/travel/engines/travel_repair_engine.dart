import 'package:uuid/uuid.dart';
import '../../../internal/storage/drift/knight_database.dart';
import 'package:drift/drift.dart';

/// Automated recovery and data integrity maintenance for Travel.
class TravelRepairEngine {
  final TravelDao travelDao;

  TravelRepairEngine({required this.travelDao});

  /// Repairs inconsistencies like bookings without trips.
  Future<void> runFullRepair() async {
    final bookings = await travelDao.getAllBookings();
    
    for (final booking in bookings) {
      if (booking.tripId == null) {
        // Log repair action
        final tripId = await _autoLink(booking);
        // Update booking with tripId
         await travelDao.upsertBooking(TravelBookingTableCompanion.insert(
          id: booking.id,
          tripId: Value(tripId),
          type: booking.type,
          provider: booking.provider,
          reference: booking.reference,
          startTime: booking.startTime,
        ));
      }
    }
  }

  Future<String> _autoLink(TravelBookingData booking) async {
    final trips = await travelDao.getAllTrips();
    for (final trip in trips) {
       if (booking.startTime.isAfter(trip.startDate) && booking.startTime.isBefore(trip.endDate)) {
         return trip.transactionId;
       }
    }
    
    // Create generic placeholder trip if nothing found
    final tripId = const Uuid().v4();
    await travelDao.insertTrip(TripTableCompanion.insert(
      id: const Uuid().v4(),
      transactionId: tripId,
      title: 'Recovered Trip',
      startDate: booking.startTime.subtract(const Duration(days: 1)),
      endDate: booking.startTime.add(const Duration(days: 7)),
      primaryType: 'unknown',
    ));
    return tripId;
  }
}
