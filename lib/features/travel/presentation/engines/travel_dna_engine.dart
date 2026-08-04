import 'package:collection/collection.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';

/// Presentation-only logic for synthesizing Travel DNA from raw data.
class TravelDnaEngine {
  const TravelDnaEngine();

  TravelDna synthesize(List<TripData> trips, List<TravelBookingData> bookings) {
    if (trips.isEmpty) return TravelDna.empty();

    // 1. Explorer Type
    final type = _calculateExplorerType(trips);

    // 2. Preferred Transport
    final transportCounts = bookings.groupListsBy((b) => b.type);
    final preferredTransport = transportCounts.keys.fold<String?>(null, (prev, element) {
      if (prev == null) return element;
      return transportCounts[element]!.length > transportCounts[prev]!.length ? element : prev;
    }) ?? 'Unknown';

    // 3. Domestic vs International
    // In a real app, we'd check country codes. 
    // For Phase 2 simulation, we'll use a placeholder ratio based on metadata.
    final internationalCount = trips.where((t) => t.metadata?.contains('International') ?? false).length;
    final domesticCount = trips.length - internationalCount;

    // 4. Preferred Season
    final months = trips.map((t) => t.startDate.month).toList();
    final preferredMonth = _mostFrequent(months) ?? 1;

    // 5. Travel Style
    final avgDuration = trips.isEmpty ? 0.0 : trips.map((t) => t.endDate.difference(t.startDate).inDays.toDouble()).average;
    final style = avgDuration > 7 ? 'Vagabond' : 'Weekender';

    return TravelDna(
      explorerType: type,
      preferredTransport: preferredTransport,
      domesticRatio: trips.isEmpty ? 0 : domesticCount / trips.length,
      internationalRatio: trips.isEmpty ? 0 : internationalCount / trips.length,
      preferredMonth: preferredMonth,
      travelStyle: style,
      averageTripDuration: avgDuration,
      totalDistance: trips.length * 1250.0, // Placeholder
    );
  }

  String _calculateExplorerType(List<TripData> trips) {
    if (trips.length > 50) return 'World Traveler';
    if (trips.length > 20) return 'Frequent Flyer';
    return 'Casual Explorer';
  }

  T? _mostFrequent<T>(Iterable<T> list) {
    if (list.isEmpty) return null;
    final counts = <T, int>{};
    for (final item in list) {
      counts[item] = (counts[item] ?? 0) + 1;
    }
    return counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}

class TravelDna {
  final String explorerType;
  final String preferredTransport;
  final double domesticRatio;
  final String travelStyle;
  final double internationalRatio;
  final int preferredMonth;
  final double averageTripDuration;
  final double totalDistance;

  TravelDna({
    required this.explorerType,
    required this.preferredTransport,
    required this.domesticRatio,
    required this.internationalRatio,
    required this.preferredMonth,
    required this.travelStyle,
    required this.averageTripDuration,
    required this.totalDistance,
  });

  factory TravelDna.empty() => TravelDna(
    explorerType: 'Beginner',
    preferredTransport: 'None',
    domesticRatio: 0,
    internationalRatio: 0,
    preferredMonth: 1,
    travelStyle: 'N/A',
    averageTripDuration: 0,
    totalDistance: 0,
  );
}
