import 'package:flutter/foundation.dart';

enum TravelType { flight, hotel, train, bus, car, other }

enum TripLifecycle { evidenceFound, building, verifying, verified, completed, archived }

enum TravelIdentity { myTravel, familyTravel, sharedTravel, unknown }

@immutable
class Trip {
  const Trip({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.destinations = const [],
    this.bookings = const [],
    this.identity = TravelIdentity.unknown,
    this.lifecycle = TripLifecycle.evidenceFound,
    this.confidenceScore = 0.0,
    this.confidenceReason,
    this.parserVersion,
  });

  final String id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> destinations;
  final List<TravelBooking> bookings;
  final TravelIdentity identity;
  final TripLifecycle lifecycle;
  final double confidenceScore;
  final String? confidenceReason;
  final String? parserVersion;
}

@immutable
class TravelBooking {
  const TravelBooking({
    required this.id,
    required this.type,
    required this.provider,
    required this.reference,
    required this.startTime,
    this.endTime,
    this.origin,
    this.destination,
    this.status = 'confirmed',
    this.confidenceScore = 0.0,
    this.identity = TravelIdentity.unknown,
    this.parserVersion,
  });

  final String id;
  final TravelType type;
  final String provider;
  final String reference;
  final DateTime startTime;
  final DateTime? endTime;
  final String? origin;
  final String? destination;
  final String status;
  final double confidenceScore;
  final TravelIdentity identity;
  final String? parserVersion;
}

@immutable
class TravelEvidence {
  const TravelEvidence({
    required this.caid,
    required this.sourceConnector,
    required this.sourceIdentifier,
    required this.rawPayload,
    required this.detectedAt,
    required this.parserVersion,
  });

  final String caid;
  final String sourceConnector;
  final String sourceIdentifier;
  final String rawPayload;
  final DateTime detectedAt;
  final String parserVersion;
}

@immutable
class TravelMetric {
  const TravelMetric({
    required this.key,
    required this.value,
    required this.lastUpdated,
    this.metadata,
  });

  final String key;
  final double value;
  final DateTime lastUpdated;
  final Map<String, dynamic>? metadata;
}

@immutable
class LocationPoint {
  const LocationPoint({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.accuracy,
    this.altitude,
    this.address,
  });

  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double? accuracy;
  final double? altitude;
  final String? address;
}
