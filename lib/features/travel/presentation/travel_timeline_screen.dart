import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/knight_tokens.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/internal/storage/drift/knight_database.dart';
import '../../../core/design_system/widgets/entrance_fader.dart';
import 'providers/travel_providers.dart';

class TravelTimelineScreen extends ConsumerStatefulWidget {
  const TravelTimelineScreen({super.key});

  @override
  ConsumerState<TravelTimelineScreen> createState() => _TravelTimelineScreenState();
}

class _TravelTimelineScreenState extends ConsumerState<TravelTimelineScreen> {
  double _zoomLevel = 1.0; // 1.0 = Month view, 0.5 = Year view, 2.0 = Trip view

  @override
  Widget build(BuildContext context) {
    final timelineAsync = ref.watch(travelTimelineProvider);

    return KnightPageScaffold(
      title: 'Time Machine',
      showBackButton: true,
      body: Column(
        children: [
          _buildZoomControls(),
          Expanded(
            child: timelineAsync.when(
              data: (data) => AnimatedSwitcher(
                duration: DesignAnimations.standard,
                child: _buildTimelineList(data),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoomControls() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Year', style: TextStyle(color: _zoomLevel < 0.7 ? DesignColors.accentBlue : Colors.white38)),
          Slider(
            value: _zoomLevel,
            min: 0.5,
            max: 2.0,
            divisions: 2,
            onChanged: (v) => setState(() => _zoomLevel = v),
          ),
          Text('Trip', style: TextStyle(color: _zoomLevel > 1.5 ? DesignColors.accentBlue : Colors.white38)),
        ],
      ),
    );
  }

  Widget _buildTimelineList(Map<int, Map<int, List<TripData>>> data) {
    final years = data.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      key: ValueKey(_zoomLevel),
      itemCount: years.length,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemBuilder: (context, index) {
        final year = years[index];
        final monthsMap = data[year]!;
        final months = monthsMap.keys.toList()..sort((a, b) => b.compareTo(a));

        return EntranceFader(
          delay: Duration(milliseconds: index * 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text('$year', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white10)),
              ),
              ...months.map((month) => _buildMonthSection(month, monthsMap[month]!)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMonthSection(int month, List<TripData> trips) {
    if (_zoomLevel < 0.7) {
       // Year view - just dots or small indicators
       return Wrap(
         spacing: 8,
         children: trips.map((t) => Container(width: 8, height: 8, decoration: const BoxDecoration(color: DesignColors.accentBlue, shape: BoxShape.circle))).toList(),
       );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 16),
          child: Text(DateFormat('MMMM').format(DateTime(2022, month)), style: KnightTokens.label),
        ),
        ...trips.map((trip) => _buildTripEntry(trip)),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildTripEntry(TripData trip) {
    return GestureDetector(
      onTap: () => context.push('${AppRoutes.travelTripStory}/${trip.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: KnightTokens.glass(accentColor: Colors.white, opacity: 0.05),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trip.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 4),
                Text('${DateFormat('MMM dd').format(trip.startDate)} - ${DateFormat('MMM dd').format(trip.endDate)}', style: const TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.white24),
          ],
        ),
      ),
    );
  }
}
