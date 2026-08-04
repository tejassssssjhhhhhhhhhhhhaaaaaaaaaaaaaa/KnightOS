import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/database_provider.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';
import '../../domain/travel_ui_models.dart';
export '../../domain/travel_ui_models.dart';
import '../engines/travel_viz_engine.dart';
import '../engines/travel_dna_engine.dart';

/// Provider for the Travel Visualization Engine.
final travelVizEngineProvider = Provider<TravelVizEngine>((ref) {
  return const TravelVizEngine();
});

/// Provider for the Travel DNA Engine.
final travelDnaEngineProvider = Provider<TravelDnaEngine>((ref) {
  return const TravelDnaEngine();
});

/// Provider for synchronized Travel DNA.
final travelDnaProvider = FutureProvider<TravelDna>((ref) async {
  final trips = await ref.watch(recentTripsProvider.future);
  final db = ref.watch(knightDatabaseProvider);
  final bookings = await db.travelDao.getAllBookings();
  final engine = ref.watch(travelDnaEngineProvider);
  return engine.synthesize(trips, bookings);
});

/// Provider for Travel AI Assistant logic.
final travelAiProvider = Provider<TravelAiService>((ref) {
  return TravelAiService(ref: ref);
});

class TravelAiService {
  final Ref ref;
  TravelAiService({required this.ref});

  Future<String> query(String text) async {
    final trips = await ref.read(recentTripsProvider.future);
    final metrics = await ref.read(travelMetricsProvider.future);
    
    final lowerText = text.toLowerCase();
    
    if (lowerText.contains('total trips') || lowerText.contains('how many trips')) {
      final count = metrics['total_trips']?.toInt() ?? 0;
      return 'You have taken a total of $count trips recorded in KnightOS.';
    }
    
    if (lowerText.contains('longest trip')) {
      final records = await ref.read(travelRecordsProvider.future);
      final longest = records['longest'];
      if (longest == null) return 'I couldn\'t find your longest trip yet.';
      final days = longest.endDate.difference(longest.startDate).inDays;
      return 'Your longest journey was "${longest.title}", which lasted $days days.';
    }

    if (lowerText.contains('goa')) {
       final goaTrips = trips.where((t) => t.title.toLowerCase().contains('goa')).toList();
       if (goaTrips.isEmpty) return 'I don\'t see any trips to Goa in your history.';
       return 'You have ${goaTrips.length} trips to Goa on record. The most recent was "${goaTrips.first.title}".';
    }

    return 'I\'ve analyzed your Travel DNA. You are a ${trips.length > 5 ? "frequent explorer" : "casual traveler"}. Ask me about your longest trips, destinations, or travel stats!';
  }
}

/// Provider for all travel metrics.
final travelMetricsProvider = FutureProvider<Map<String, double>>((ref) async {
  final db = ref.watch(knightDatabaseProvider);
  final metrics = await db.travelDao.getAllMetrics();
  return {for (var m in metrics) m.metricKey: m.metricValue};
});

/// Provider for recent trips from the Knowledge Graph.
final recentTripsProvider = FutureProvider<List<TripData>>((ref) async {
  final db = ref.watch(knightDatabaseProvider);
  final trips = await db.travelDao.getAllTrips();
  return trips..sort((a, b) => b.startDate.compareTo(a.startDate));
});

/// Provider for trips grouped by year/month for Time Machine.
final travelTimelineProvider = FutureProvider<Map<int, Map<int, List<TripData>>>>((ref) async {
  final trips = await ref.watch(recentTripsProvider.future);
  final grouped = <int, Map<int, List<TripData>>>{};
  for (final trip in trips) {
    final year = trip.startDate.year;
    final month = trip.startDate.month;
    grouped.putIfAbsent(year, () => {});
    grouped[year]!.putIfAbsent(month, () => []);
    grouped[year]![month]!.add(trip);
  }
  return grouped;
});

/// Provider for "On This Day" memories.
final onThisDayMemoriesProvider = FutureProvider<List<TripData>>((ref) async {
  final trips = await ref.watch(recentTripsProvider.future);
  final now = DateTime.now();
  return trips.where((t) => t.startDate.month == now.month && t.startDate.day == now.day && t.startDate.year < now.year).toList();
});

/// Provider for travel records (Longest, Shortest, First).
final travelRecordsProvider = FutureProvider<Map<String, TripData?>>((ref) async {
  final trips = await ref.watch(recentTripsProvider.future);
  if (trips.isEmpty) return {};
  
  final firstTrip = trips.reduce((a, b) => a.startDate.isBefore(b.startDate) ? a : b);
  final longestTrip = trips.reduce((a, b) => (a.endDate.difference(a.startDate)) > (b.endDate.difference(b.startDate)) ? a : b);
  
  return {
    'first': firstTrip,
    'longest': longestTrip,
  };
});

/// Provider for a specific Trip's complete story.
final tripStoryProvider = FutureProvider.family<TripStory, String>((ref, tripId) async {
  final db = ref.watch(knightDatabaseProvider);
  final trip = await (db.select(db.tripTable)..where((t) => t.id.equals(tripId))).getSingle();
  final bookings = await db.travelDao.getBookingsForTrip(tripId);
  return TripStory(trip: trip, bookings: bookings);
});

/// Provider for intelligent highlights.
final travelHighlightsProvider = FutureProvider<List<TravelHighlight>>((ref) async {
  final trips = await ref.watch(recentTripsProvider.future);
  if (trips.isEmpty) return [];

  final highlights = <TravelHighlight>[];

  // 1. Highest Confidence
  final highConf = trips.reduce((a, b) => a.confidenceScore > b.confidenceScore ? a : b);
  highlights.add(TravelHighlight(title: 'Reliable Journey', description: 'Highest data confidence: ${highConf.title}', icon: Icons.verified_user));

  // 2. Favorite Destination (Most Frequent City)
  final cities = trips.map((t) => t.title).toList(); // Simplified
  final favorite = _mostFrequent(cities);
  if (favorite != null) {
     highlights.add(TravelHighlight(title: 'Home Away From Home', description: 'Your most visited: $favorite', icon: Icons.favorite));
  }

  // 3. Most Active Year
  final years = trips.map((t) => t.startDate.year).toList();
  final topYear = _mostFrequent(years);
  if (topYear != null) {
     highlights.add(TravelHighlight(title: 'Wanderlust Peak', description: 'Most active travel year: $topYear', icon: Icons.trending_up));
  }

  return highlights;
});

/// Provider for travel recommendations.
final travelRecommendationsProvider = FutureProvider<List<TravelRecommendation>>((ref) async {
  final dna = await ref.watch(travelDnaProvider.future);
  
  final recommendations = <TravelRecommendation>[];
  
  if (dna.travelStyle == 'Weekender') {
    recommendations.add(const TravelRecommendation(
      title: 'Quick Escape: Mussoorie',
      reason: 'Matches your weekend getaway pattern.',
      icon: Icons.landscape,
    ));
  }
  
  if (dna.preferredMonth == DateTime.now().month) {
    recommendations.add(const TravelRecommendation(
      title: 'Peak Season Alert',
      reason: 'This is your historically most active month!',
      icon: Icons.timer,
    ));
  }

  return recommendations;
});

String? _mostFrequent(List<dynamic> list) {
  if (list.isEmpty) return null;
  final counts = <dynamic, int>{};
  for (final item in list) {
    counts[item] = (counts[item] ?? 0) + 1;
  }
  return counts.entries.reduce((a, b) => a.value > b.value ? a : b).key.toString();
}

/// Provider for synchronization status.
final travelSyncStatusProvider = Provider<String>((ref) {
  return 'Cloud & Local Synced';
});

/// Provider for geographic enrichment data.
final travelGeoEnrichmentProvider = FutureProvider<List<TravelGeographicEnrichmentData>>((ref) async {
  final db = ref.watch(knightDatabaseProvider);
  // Future: Add method to travelDao to get all geo enrichment
  return await db.select(db.travelGeographicEnrichmentTable).get();
});

/// Provider for travel search results.
final travelSearchProvider = FutureProvider.family<List<TripData>, String>((ref, query) async {
  final db = ref.watch(knightDatabaseProvider);
  final allTrips = await db.travelDao.getAllTrips();
  if (query.isEmpty) return [];
  
  final normalizedQuery = query.toLowerCase();
  return allTrips.where((trip) {
    return trip.title.toLowerCase().contains(normalizedQuery) ||
           trip.primaryType.toLowerCase().contains(normalizedQuery) ||
           (trip.metadata?.toLowerCase().contains(normalizedQuery) ?? false);
  }).toList();
});
