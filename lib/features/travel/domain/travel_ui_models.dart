import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/internal/storage/drift/knight_database.dart';

class TravelRecommendation {
  final String title;
  final String reason;
  final IconData icon;
  const TravelRecommendation({required this.title, required this.reason, required this.icon});
}

class TravelHighlight {
  final String title;
  final String description;
  final IconData icon;
  TravelHighlight({required this.title, required this.description, required this.icon});
}

class TripStory {
  final TripData trip;
  final List<TravelBookingData> bookings;
  TripStory({required this.trip, required this.bookings});
}

class TravelCluster {
  final LatLng center;
  final List<TravelGeographicEnrichmentData> items;
  TravelCluster({required this.center, required this.items});
  
  bool get isSingle => items.length == 1;
  String? get category => items.isNotEmpty ? items.first.category : null;
}
