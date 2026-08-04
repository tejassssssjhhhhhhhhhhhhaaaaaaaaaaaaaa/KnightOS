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
import 'travel_search_delegate.dart';

class TravelHomeScreen extends ConsumerWidget {
  const TravelHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsAsync = ref.watch(travelMetricsProvider);
    final tripsAsync = ref.watch(recentTripsProvider);
    final syncStatus = ref.watch(travelSyncStatusProvider);
    final highlightsAsync = ref.watch(travelHighlightsProvider);
    final recommendationsAsync = ref.watch(travelRecommendationsProvider);

    return KnightPageScaffold(
      title: 'Travel',
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(travelMetricsProvider);
          ref.invalidate(recentTripsProvider);
          ref.invalidate(travelHighlightsProvider);
          ref.invalidate(travelRecommendationsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(DesignSpacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EntranceFader(child: _buildHeader(context, syncStatus)),
              const SizedBox(height: DesignSpacing.xl),
              EntranceFader(delay: const Duration(milliseconds: 100), child: _buildSearchBar(context)),
              const SizedBox(height: DesignSpacing.xl),
              EntranceFader(delay: const Duration(milliseconds: 200), child: _buildSummaryCards(metricsAsync)),
              const SizedBox(height: DesignSpacing.xl),
              EntranceFader(delay: const Duration(milliseconds: 300), child: _buildHighlights(context, highlightsAsync)),
              const SizedBox(height: DesignSpacing.xl),
              EntranceFader(delay: const Duration(milliseconds: 400), child: _buildRecommendations(context, recommendationsAsync)),
              const SizedBox(height: DesignSpacing.xl),
              EntranceFader(delay: const Duration(milliseconds: 500), child: _buildContinueTrip(context, tripsAsync)),
              const SizedBox(height: DesignSpacing.xl),
              EntranceFader(delay: const Duration(milliseconds: 600), child: _buildQuickActions(context)),
              const SizedBox(height: DesignSpacing.xl),
              EntranceFader(delay: const Duration(milliseconds: 700), child: _buildUpcomingTrips(context, tripsAsync)),
              const SizedBox(height: DesignSpacing.xl),
              EntranceFader(delay: const Duration(milliseconds: 800), child: _buildRecentTrips(context, tripsAsync)),
              const SizedBox(height: DesignSpacing.xl),
              EntranceFader(delay: const Duration(milliseconds: 900), child: _buildImportStatus(context)),
              const SizedBox(height: 100), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String syncStatus) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          label: 'Explore the World header',
          child: const Text('Explore the World', style: KnightTokens.headline),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.sync, size: 14, color: Colors.white24),
            const SizedBox(width: 8),
            Semantics(
              label: 'Synchronization status',
              value: syncStatus,
              child: Text(
                'Status: $syncStatus',
                style: KnightTokens.subheadline,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Search travel trips and locations',
      child: GestureDetector(
        onTap: () => showSearch(context: context, delegate: TravelSearchDelegate()),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: KnightTokens.glass(accentColor: Colors.white, opacity: 0.1),
          child: const Row(
            children: [
              Icon(Icons.search, color: Colors.white38),
              SizedBox(width: 16),
              Text('Search cities, trips, or evidence...', style: TextStyle(color: Colors.white38)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(AsyncValue<Map<String, double>> metricsAsync) {
    return metricsAsync.when(
      data: (metrics) => GridValueList(
        children: [
          _StatCard(label: 'TOTAL TRIPS', value: metrics['total_trips']?.toInt().toString() ?? '0', icon: Icons.map_outlined),
          _StatCard(label: 'COUNTRIES', value: metrics['countries_visited']?.toInt().toString() ?? '0', icon: Icons.public),
          _StatCard(label: 'FLIGHTS', value: metrics['total_flights']?.toInt().toString() ?? '0', icon: Icons.flight_takeoff),
          _StatCard(label: 'HOTEL NIGHTS', value: metrics['total_hotel_nights']?.toInt().toString() ?? '0', icon: Icons.bed_outlined),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error loading metrics: $e'),
    );
  }

  Widget _buildHighlights(BuildContext context, AsyncValue<List<TravelHighlight>> highlightsAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('TRAVEL HIGHLIGHTS', style: KnightTokens.label),
        const SizedBox(height: 16),
        highlightsAsync.when(
          data: (highlights) {
            if (highlights.isEmpty) return const Text('No highlights yet.', style: TextStyle(color: Colors.white24));
            return SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: highlights.length,
                itemBuilder: (context, index) {
                  final h = highlights[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: _HighlightCard(title: h.title, value: h.description, icon: h.icon),
                  );
                },
              ),
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (e, s) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildRecommendations(BuildContext context, AsyncValue<List<TravelRecommendation>> recommendationsAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('SMART RECOMMENDATIONS', style: KnightTokens.label),
        const SizedBox(height: 16),
        recommendationsAsync.when(
          data: (list) {
            if (list.isEmpty) return const SizedBox.shrink();
            return Column(
              children: list.map((r) => _RecommendationTile(rec: r)).toList(),
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (e, s) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildContinueTrip(BuildContext context, AsyncValue<List<TripData>> tripsAsync) {
    return tripsAsync.when(
      data: (trips) {
        if (trips.isEmpty) return const SizedBox.shrink();
        final lastTrip = trips.last;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('CONTINUE EXPLORING', style: KnightTokens.label),
            const SizedBox(height: 16),
            _TripHeroCard(trip: lastTrip),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (e, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('QUICK ACTIONS', style: KnightTokens.label),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _ActionChip(label: 'Timeline', icon: Icons.timeline, onTap: () => context.push(AppRoutes.travelTimeline)),
              _ActionChip(label: 'Map', icon: Icons.map, onTap: () => context.push(AppRoutes.travelCommandCenter)),
              _ActionChip(label: 'Lane', icon: Icons.auto_awesome_rounded, onTap: () => context.push(AppRoutes.travelMemoryLane)),
              _ActionChip(label: 'DNA', icon: Icons.fingerprint, onTap: () => context.push(AppRoutes.travelDna)),
              _ActionChip(label: 'Ask AI', icon: Icons.chat_bubble_outline_rounded, onTap: () => context.push(AppRoutes.travelAssistant)),
              _ActionChip(label: 'Import', icon: Icons.import_export, onTap: () => context.push(AppRoutes.travelImport)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingTrips(BuildContext context, AsyncValue<List<TripData>> tripsAsync) {
    return tripsAsync.when(
      data: (trips) {
        final upcoming = trips.where((t) => t.startDate.isAfter(DateTime.now())).toList();
        if (upcoming.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('UPCOMING TRIPS', style: KnightTokens.label),
            const SizedBox(height: 16),
            ...upcoming.map((trip) => _TripListTile(trip: trip)),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (e, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildRecentTrips(BuildContext context, AsyncValue<List<TripData>> tripsAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('RECENT TRIPS', style: KnightTokens.label),
            TextButton(onPressed: () {}, child: const Text('VIEW ALL', style: TextStyle(fontSize: 10))),
          ],
        ),
        const SizedBox(height: 12),
        tripsAsync.when(
          data: (trips) {
            final recent = trips.where((t) => t.startDate.isBefore(DateTime.now())).toList().reversed.toList();
            if (recent.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: Text('No trips discovered yet.', style: TextStyle(color: Colors.white24))),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recent.length > 3 ? 3 : recent.length,
              itemBuilder: (context, index) => _TripListTile(trip: recent[index]),
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (e, s) => Text('Error: $e'),
        ),
      ],
    );
  }

  Widget _buildImportStatus(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: KnightTokens.glass(accentColor: DesignColors.accentBlue, opacity: 0.05),
      child: const Column(
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: DesignColors.accentBlue, size: 18),
              SizedBox(width: 12),
              Text('Active Discovery', style: TextStyle(fontWeight: FontWeight.bold)),
              Spacer(),
              Text('84%', style: TextStyle(color: DesignColors.accentBlue, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 16),
          LinearProgressIndicator(value: 0.84, color: DesignColors.accentBlue, backgroundColor: Colors.white10),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('42 Travel emails detected', style: TextStyle(fontSize: 11, color: Colors.white38)),
              Text('156 GPS photos linked', style: TextStyle(fontSize: 11, color: Colors.white38)),
            ],
          ),
        ],
      ),
    );
  }
}

class GridValueList extends StatelessWidget {
  const GridValueList({required this.children, super.key});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.6,
      children: children,
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: KnightTokens.glass(accentColor: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: Colors.white24),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          Text(label, style: const TextStyle(fontSize: 9, color: Colors.white38, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
        ],
      ),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  const _HighlightCard({required this.title, required this.value, required this.icon});
  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: KnightTokens.glass(accentColor: DesignColors.travel, opacity: 0.08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: DesignColors.travel.withValues(alpha: 0.5)),
          const Spacer(),
          Text(title, style: const TextStyle(fontSize: 10, color: Colors.white24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _RecommendationTile extends StatelessWidget {
  const _RecommendationTile({required this.rec});
  final TravelRecommendation rec;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: KnightTokens.radiusCard),
      child: Row(
        children: [
          Icon(rec.icon, color: DesignColors.accentBlue, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rec.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(rec.reason, style: const TextStyle(fontSize: 10, color: Colors.white38)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.label, required this.icon, required this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: ActionChip(
        onPressed: onTap,
        backgroundColor: Colors.white.withValues(alpha: 0.05),
        avatar: Icon(icon, size: 16, color: DesignColors.accentBlue),
        label: Text(label, style: const TextStyle(fontSize: 12)),
        shape: RoundedRectangleBorder(borderRadius: KnightTokens.radiusPill),
      ),
    );
  }
}

class _TripHeroCard extends StatelessWidget {
  const _TripHeroCard({required this.trip});
  final TripData trip;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [DesignColors.accentBlue.withValues(alpha: 0.2), DesignColors.background],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: KnightTokens.radiusCard,
        border: Border.all(color: DesignColors.accentBlue.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(color: DesignColors.accentBlue.withValues(alpha: 0.1), blurRadius: 40, spreadRadius: -10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flight_takeoff, color: DesignColors.accentBlue, size: 20),
              const SizedBox(width: 12),
              Text(trip.primaryType.toUpperCase(), style: KnightTokens.label.copyWith(color: DesignColors.accentBlue)),
            ],
          ),
          const SizedBox(height: 20),
          Text(trip.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          Text(
            '${DateFormat('MMM dd').format(trip.startDate)} - ${DateFormat('MMM dd').format(trip.endDate)}',
            style: const TextStyle(color: Colors.white38),
          ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: DesignColors.accentBlue,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: KnightTokens.radiusPill),
            ),
            child: const Text('VIEW DETAILS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

class _TripListTile extends StatelessWidget {
  const _TripListTile({required this.trip});
  final TripData trip;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white.withValues(alpha: 0.03),
      shape: RoundedRectangleBorder(borderRadius: KnightTokens.radiusCard),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        title: Text(trip.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            '${dateFormat.format(trip.startDate)} - ${dateFormat.format(trip.endDate)}',
            style: const TextStyle(fontSize: 12, color: Colors.white38),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getConfidenceColor(trip.confidenceScore).withValues(alpha: 0.1),
            borderRadius: KnightTokens.radiusPill,
          ),
          child: Text(
            '${(trip.confidenceScore * 100).toInt()}% Conf',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _getConfidenceColor(trip.confidenceScore)),
          ),
        ),
      ),
    );
  }

  Color _getConfidenceColor(double score) {
    if (score > 0.8) return Colors.greenAccent;
    if (score > 0.5) return Colors.orangeAccent;
    return Colors.redAccent;
  }
}
