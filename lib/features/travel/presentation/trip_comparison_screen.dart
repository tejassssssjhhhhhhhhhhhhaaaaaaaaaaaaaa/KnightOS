import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/design_system/widgets/entrance_fader.dart';
import 'providers/travel_providers.dart';

class TripComparisonScreen extends ConsumerStatefulWidget {
  const TripComparisonScreen({required this.tripIds, super.key});
  final List<String> tripIds;

  @override
  ConsumerState<TripComparisonScreen> createState() => _TripComparisonScreenState();
}

class _TripComparisonScreenState extends ConsumerState<TripComparisonScreen> {
  @override
  Widget build(BuildContext context) {
    return KnightPageScaffold(
      title: 'Compare Journeys',
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignSpacing.l),
        child: Column(
          children: [
            Row(
              children: widget.tripIds.map((id) => Expanded(child: _buildTripColumn(id))).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripColumn(String tripId) {
    final storyAsync = ref.watch(tripStoryProvider(tripId));
    return storyAsync.when(
      data: (story) => EntranceFader(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Text(story.trip.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              _CompareMetric(label: 'DURATION', value: '${story.trip.endDate.difference(story.trip.startDate).inDays} d'),
              _CompareMetric(label: 'BOOKINGS', value: '${story.bookings.length}'),
              _CompareMetric(label: 'CONFIDENCE', value: '${(story.trip.confidenceScore * 100).toInt()}%'),
              _CompareMetric(label: 'TYPE', value: story.trip.primaryType.toUpperCase()),
            ],
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => const Text('Error'),
    );
  }
}

class _CompareMetric extends StatelessWidget {
  const _CompareMetric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 8, color: Colors.white24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
