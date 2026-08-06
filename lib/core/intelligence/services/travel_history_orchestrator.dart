import 'dart:async';
import 'package:drift/drift.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../internal/utils/knight_logger.dart';

class TravelHistoryOrchestrator {
  TravelHistoryOrchestrator({required this.db});
  final KnightDatabase db;

  Future<void> reconstructTravelHistory() async {
    KnightLogger.info('[TRAVEL] Reconstructing travel history from evidence...');

    final bookings = await (db.select(db.extractedEntityTable)..where((t) => t.entityType.equals('booking'))).get();
    final calendarEvents = await (db.select(db.googleResourceTable)..where((t) => t.resourceType.equals('calendar'))).get();

    final List<TripTableCompanion> trips = [];

    // 1. Process Bookings (Flights, Hotels, Train, Bus)
    for (final booking in bookings) {
      trips.add(TripTableCompanion.insert(
        id: booking.id,
        transactionId: booking.id,
        title: booking.title,
        startDate: booking.eventTimestamp,
        endDate: booking.eventTimestamp.add(_getDuration(booking.entitySubtype)),
        primaryType: booking.entitySubtype,
        lifecycleState: const Value('verified'),
        confidenceScore: const Value(0.9),
      ));
    }

    // 2. Process Calendar (Vacation, Trip)
    for (final event in calendarEvents) {
      if (event.title.toLowerCase().contains('trip') || event.title.toLowerCase().contains('flight')) {
        trips.add(TripTableCompanion.insert(
          id: event.id,
          transactionId: event.id,
          title: event.title,
          startDate: event.resourceDate,
          endDate: event.resourceDate.add(const Duration(days: 1)),
          primaryType: 'calendar_event',
          lifecycleState: const Value('evidence_found'),
          confidenceScore: const Value(0.7),
        ));
      }
    }

    await db.batch((batch) {
      for (final trip in trips) {
        batch.insert(db.tripTable, trip, mode: InsertMode.insertOrReplace);
      }
    });

    KnightLogger.info('[TRAVEL] History reconstruction complete. Found ${trips.length} potential trips.');
  }

  Duration _getDuration(String subtype) {
    switch (subtype) {
      case 'flight': return const Duration(hours: 4);
      case 'hotel': return const Duration(days: 1);
      case 'train': return const Duration(hours: 8);
      case 'bus': return const Duration(hours: 12);
      default: return const Duration(hours: 2);
    }
  }
}
