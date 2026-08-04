import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/design_system/knight_tokens.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/internal/storage/drift/knight_database.dart';
import '../../../core/design_system/widgets/entrance_fader.dart';
import 'providers/travel_providers.dart';

class TravelSearchDelegate extends SearchDelegate<TripData?> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final searchAsync = ref.watch(travelSearchProvider(query));
        return searchAsync.when(
          data: (results) {
            if (results.isEmpty) {
              return Center(child: Text('No results for "$query"'));
            }
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final trip = results[index];
                return EntranceFader(
                  delay: Duration(milliseconds: index * 50),
                  child: _TripResultTile(
                    trip: trip,
                    onTap: () => close(context, trip),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text(
          'Start typing to search trips...',
          style: TextStyle(color: Colors.white24),
        ),
      );
    }
    return buildResults(context);
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(backgroundColor: DesignColors.surface),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white38),
        border: InputBorder.none,
      ),
    );
  }
}

class _TripResultTile extends StatelessWidget {
  const _TripResultTile({required this.trip, required this.onTap});
  final TripData trip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    return Card(
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      color: Colors.white.withValues(alpha: 0.03),
      shape: RoundedRectangleBorder(borderRadius: KnightTokens.radiusCard),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        onTap: onTap,
        title: Text(
          trip.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
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
            color: _getConfidenceColor(trip.confidenceScore).withValues(
              alpha: 0.1,
            ),
            borderRadius: KnightTokens.radiusPill,
          ),
          child: Text(
            '${(trip.confidenceScore * 100).toInt()}% Conf',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: _getConfidenceColor(trip.confidenceScore),
            ),
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
