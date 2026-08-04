import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/knight_tokens.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/internal/storage/drift/knight_database.dart';
import '../../../core/design_system/widgets/entrance_fader.dart';
import 'providers/travel_providers.dart';
import 'engines/travel_replay_engine.dart';

class TripStoryScreen extends ConsumerWidget {
  const TripStoryScreen({required this.tripId, super.key});
  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyAsync = ref.watch(tripStoryProvider(tripId));

    return KnightPageScaffold(
      title: 'Journey Story',
      showBackButton: true,
      body: storyAsync.when(
        data: (story) => _buildStoryBody(context, story),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildStoryBody(BuildContext context, TripStory story) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EntranceFader(child: _buildHeroHeader(context, story.trip)),
          const SizedBox(height: 32),
          EntranceFader(delay: const Duration(milliseconds: 200), child: _buildAiSummary(story)),
          const SizedBox(height: 32),
          EntranceFader(delay: const Duration(milliseconds: 400), child: _buildTimeline(story.bookings)),
          const SizedBox(height: 48),
          EntranceFader(delay: const Duration(milliseconds: 600), child: _buildQuickStats(story.trip, story.bookings)),
          const SizedBox(height: 48),
          EntranceFader(delay: const Duration(milliseconds: 700), child: const Text('EXPENSES', style: KnightTokens.label)),
          const SizedBox(height: 16),
          EntranceFader(delay: const Duration(milliseconds: 800), child: _buildExpensePlaceholder()),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildAiSummary(TripStory story) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: DesignColors.accentPurple.withValues(alpha: 0.05),
        borderRadius: KnightTokens.radiusCard,
        border: Border.all(color: DesignColors.accentPurple.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: DesignColors.accentPurple, size: 16),
              SizedBox(width: 12),
              Text('SMART SUMMARY', style: TextStyle(color: DesignColors.accentPurple, fontWeight: FontWeight.bold, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'This was a ${story.trip.primaryType} journey spanning ${story.trip.endDate.difference(story.trip.startDate).inDays} days. '
            'You visited ${story.trip.title} and had ${story.bookings.length} confirmed bookings. '
            'The trip was highly efficient with a confidence score of ${(story.trip.confidenceScore * 100).toInt()}%.',
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context, TripData trip) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: KnightTokens.glass(accentColor: DesignColors.accentBlue, opacity: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(trip.title, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          Text(
            '${DateFormat('MMMM dd').format(trip.startDate)} - ${DateFormat('MMMM dd, yyyy').format(trip.endDate)}',
            style: const TextStyle(color: Colors.white38),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              _StoryChip(label: trip.primaryType.toUpperCase(), icon: Icons.flight_takeoff),
              const SizedBox(width: 12),
              const _StoryChip(label: 'VERIFIED', icon: Icons.verified, color: DesignColors.success),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.play_circle_fill, color: DesignColors.accentBlue, size: 48),
                onPressed: () => _showReplayOverlay(context, trip),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showReplayOverlay(BuildContext context, TripData trip) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ReplaySheet(tripId: trip.id),
    );
  }

  Widget _buildTimeline(List<TravelBookingData> bookings) {
    if (bookings.isEmpty) return const Text('No detailed itinerary found.', style: TextStyle(color: Colors.white24));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('ITINERARY', style: KnightTokens.label),
        const SizedBox(height: 20),
        ...bookings.map((b) => _BookingTile(booking: b)),
      ],
    );
  }

  Widget _buildQuickStats(TripData trip, List<TravelBookingData> bookings) {
    final duration = trip.endDate.difference(trip.startDate).inDays;
    return Row(
      children: [
        _MiniStatStory(label: 'DURATION', value: '$duration DAYS'),
        const SizedBox(width: 16),
        _MiniStatStory(label: 'EVENTS', value: '${bookings.length} BOOKINGS'),
      ],
    );
  }

  Widget _buildExpensePlaceholder() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DesignColors.white05,
        borderRadius: KnightTokens.radiusCard,
        border: Border.all(color: DesignColors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('Total Tracked Cost', style: TextStyle(color: Colors.white38)),
          Text('\$4,250.00', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }
}

class _StoryChip extends StatelessWidget {
  const _StoryChip({required this.label, required this.icon, this.color});
  final String label;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (color ?? DesignColors.accentBlue).withValues(alpha: 0.1),
        borderRadius: KnightTokens.radiusPill,
        border: Border.all(color: (color ?? DesignColors.accentBlue).withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color ?? DesignColors.accentBlue),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color ?? DesignColors.accentBlue)),
        ],
      ),
    );
  }
}

class _BookingTile extends StatelessWidget {
  const _BookingTile({required this.booking});
  final TravelBookingData booking;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8, color: DesignColors.accentBlue.withValues(alpha: 0.5)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(booking.type.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(booking.provider, style: const TextStyle(color: Colors.white24, fontSize: 10)),
              ],
            ),
          ),
          Text(DateFormat('MMM dd').format(booking.startTime), style: const TextStyle(color: Colors.white38, fontSize: 12)),
        ],
      ),
    );
  }
}

class _MiniStatStory extends StatelessWidget {
  const _MiniStatStory({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: KnightTokens.glass(accentColor: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 8, color: Colors.white24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}

class _ReplaySheet extends ConsumerStatefulWidget {
  const _ReplaySheet({required this.tripId});
  final String tripId;

  @override
  ConsumerState<_ReplaySheet> createState() => _ReplaySheetState();
}

class _ReplaySheetState extends ConsumerState<_ReplaySheet> {
  TravelReplayEngine? _engine;

  @override
  Widget build(BuildContext context) {
    final storyAsync = ref.watch(tripStoryProvider(widget.tripId));

    return storyAsync.when(
      data: (story) {
        _engine ??= TravelReplayEngine(trip: story.trip, bookings: story.bookings);
        return ListenableBuilder(
          listenable: _engine!,
          builder: (context, _) => Container(
            height: 300,
            decoration: const BoxDecoration(
              color: DesignColors.background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 40, spreadRadius: 10)],
            ),
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('JOURNEY REPLAY', style: KnightTokens.label),
                    Text('${(_engine!.progress * 100).toInt()}%', style: const TextStyle(color: DesignColors.accentBlue, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Spacer(),
                Slider(
                  value: _engine!.progress,
                  onChanged: (v) => _engine!.seek(v),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.speed, size: 20),
                      onPressed: () => _engine!.setSpeed(_engine!.playbackSpeed == 1.0 ? 2.0 : 1.0),
                      color: _engine!.playbackSpeed > 1.0 ? DesignColors.accentBlue : Colors.white24,
                    ),
                    const SizedBox(width: 32),
                    GestureDetector(
                      onTap: () => _engine!.isPlaying ? _engine!.pause() : _engine!.play(),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(color: DesignColors.accentBlue, shape: BoxShape.circle),
                        child: Icon(_engine!.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 32),
                    IconButton(
                      icon: const Icon(Icons.stop, size: 20),
                      onPressed: () => _engine!.seek(0),
                      color: Colors.white24,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (e, s) => const SizedBox.shrink(),
    );
  }
}
