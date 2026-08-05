import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/features/travel/presentation/engines/travel_dna_engine.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';

void main() {
  late TravelDnaEngine engine;

  setUp(() {
    engine = const TravelDnaEngine();
  });

  TripData _mockTrip({
    required String id,
    required String title,
    required DateTime start,
    required DateTime end,
    String? metadata,
  }) {
    return TripData(
      id: id,
      title: title,
      startDate: start,
      endDate: end,
      primaryType: 'leisure',
      confidenceScore: 0.9,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      version: 1,
      isDeleted: false,
      syncStatus: 'synced',
      transactionId: 'tx-1',
      identity: 'user-1',
      lifecycleState: 'active',
      metadata: metadata,
    );
  }

  group('TravelDnaEngine Synthesis Tests', () {
    test('Empty trips returns empty DNA', () {
      final dna = engine.synthesize([], []);
      expect(dna.explorerType, 'Beginner');
      expect(dna.totalDistance, 0);
    });

    test('Identifies Weekender travel style', () {
      final trips = <TripData>[
        _mockTrip(
          id: '1',
          title: 'Goa',
          start: DateTime(2024, 1, 1),
          end: DateTime(2024, 1, 3), // 2 days
        ),
      ];
      final dna = engine.synthesize(trips, []);
      expect(dna.travelStyle, 'Weekender');
    });

    test('Identifies Vagabond travel style for long trips', () {
      final trips = <TripData>[
        _mockTrip(
          id: '1',
          title: 'Europe',
          start: DateTime(2024, 1, 1),
          end: DateTime(2024, 1, 15), // 14 days
        ),
      ];
      final dna = engine.synthesize(trips, []);
      expect(dna.travelStyle, 'Vagabond');
    });
  });
}
