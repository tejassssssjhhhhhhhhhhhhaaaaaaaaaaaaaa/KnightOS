import 'package:uuid/uuid.dart';
import '../../../internal/storage/drift/knight_database.dart';
import 'package:drift/drift.dart';

/// Manages relationships between trips, bookings, and other life events.
class TravelKnowledgeGraph {
  final TravelDao travelDao;

  TravelKnowledgeGraph({required this.travelDao});

  /// Links a booking to a trip.
  Future<void> linkBookingToTrip(String bookingId, String tripId) async {
    final booking = await travelDao.getBooking(bookingId);
    if (booking != null) {
      await travelDao.upsertBooking(TravelBookingTableCompanion.insert(
        id: booking.id,
        transactionId: Value(booking.id), // Using existing ID as logicalId
        tripId: Value(tripId),
        type: booking.type,
        provider: booking.provider,
        reference: booking.reference,
        startTime: booking.startTime,
        endTime: Value(booking.endTime),
        origin: Value(booking.origin),
        destination: Value(booking.destination),
        status: Value(booking.status),
      ));
    }
  }

  /// Finds or creates a trip for a booking based on dates and logic.
  Future<String> findOrCreateTrip(TravelBookingData booking) async {
    final existingTrips = await travelDao.getAllTrips();
    
    for (final trip in existingTrips) {
      if (booking.startTime.isAfter(trip.startDate) && booking.startTime.isBefore(trip.endDate)) {
        return trip.transactionId; // trip.transactionId is logical ID
      }
    }

    final newTripId = const Uuid().v4();
    await travelDao.insertTrip(TripTableCompanion.insert(
      id: const Uuid().v4(),
      transactionId: newTripId,
      title: 'New Trip (${booking.destination ?? 'Unknown'})',
      startDate: booking.startTime,
      endDate: booking.endTime ?? booking.startTime.add(const Duration(days: 3)),
      primaryType: booking.type,
    ));

    return newTripId;
  }
}
