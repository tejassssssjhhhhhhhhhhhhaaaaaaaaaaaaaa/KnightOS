import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/knight_tokens.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/internal/storage/drift/knight_database.dart';
import '../../../core/design_system/widgets/entrance_fader.dart';
import 'providers/travel_providers.dart';

class MemoryLaneScreen extends ConsumerWidget {
  const MemoryLaneScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onThisDayAsync = ref.watch(onThisDayMemoriesProvider);
    final recordsAsync = ref.watch(travelRecordsProvider);

    return KnightPageScaffold(
      title: 'Memory Lane',
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EntranceFader(child: _buildOnThisDay(onThisDayAsync)),
            const SizedBox(height: 48),
            EntranceFader(delay: const Duration(milliseconds: 200), child: _buildRecords(recordsAsync)),
            const SizedBox(height: 48),
            EntranceFader(delay: const Duration(milliseconds: 400), child: const Text('RECENT MEMORIES', style: KnightTokens.label)),
            const SizedBox(height: 16),
            EntranceFader(delay: const Duration(milliseconds: 600), child: _buildMemoryGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildOnThisDay(AsyncValue<List<TripData>> memories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.history, color: DesignColors.accentBlue, size: 18),
            const SizedBox(width: 12),
            const Text('ON THIS DAY', style: KnightTokens.label),
          ],
        ),
        const SizedBox(height: 20),
        memories.when(
          data: (data) {
            if (data.isEmpty) return const Text('No memories found for today.', style: TextStyle(color: Colors.white24));
            return Column(
              children: data.map((trip) => _MemoryCard(trip: trip)).toList(),
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text('Error: $e'),
        ),
      ],
    );
  }

  Widget _buildRecords(AsyncValue<Map<String, TripData?>> records) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('HALL OF FAME', style: KnightTokens.label),
        const SizedBox(height: 20),
        records.when(
          data: (data) => GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _RecordCard(title: 'FIRST FLIGHT', trip: data['first']),
              _RecordCard(title: 'LONGEST TRIP', trip: data['longest']),
            ],
          ),
          loading: () => const SizedBox.shrink(),
          error: (e, s) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildMemoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: 9,
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          color: DesignColors.white05,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.photo, color: Colors.white10),
      ),
    );
  }
}

class _MemoryCard extends StatelessWidget {
  const _MemoryCard({required this.trip});
  final TripData trip;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: KnightTokens.glass(accentColor: DesignColors.accentBlue, opacity: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${DateTime.now().year - trip.startDate.year} YEARS AGO', style: const TextStyle(color: DesignColors.accentBlue, fontWeight: FontWeight.bold, fontSize: 10)),
          const SizedBox(height: 8),
          Text(trip.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(DateFormat('MMM dd, yyyy').format(trip.startDate), style: const TextStyle(color: Colors.white38)),
        ],
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  const _RecordCard({required this.title, required this.trip});
  final String title;
  final TripData? trip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: KnightTokens.glass(accentColor: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white24)),
          const Spacer(),
          Text(trip?.title ?? '---', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(trip != null ? DateFormat('yyyy').format(trip!.startDate) : '', style: const TextStyle(fontSize: 10, color: Colors.white38)),
        ],
      ),
    );
  }
}
