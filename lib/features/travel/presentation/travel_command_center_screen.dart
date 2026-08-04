import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/design_system/knight_tokens.dart';
import '../../../core/internal/storage/drift/knight_database.dart';
import '../../../core/design_system/widgets/entrance_fader.dart';
import 'providers/travel_providers.dart';
import 'engines/travel_viz_engine.dart';
import 'travel_search_delegate.dart';

class TravelCommandCenterScreen extends ConsumerStatefulWidget {
  const TravelCommandCenterScreen({super.key});

  @override
  ConsumerState<TravelCommandCenterScreen> createState() => _TravelCommandCenterScreenState();
}

class _TravelCommandCenterScreenState extends ConsumerState<TravelCommandCenterScreen> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  String? _selectedLocationId;
  final Set<String> _enabledLayers = {'flights', 'hotels', 'photos', 'trips'};

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(begin: _mapController.camera.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(begin: _mapController.camera.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: _mapController.camera.zoom, end: destZoom);

    final controller = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    final animation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      _mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final metricsAsync = ref.watch(travelMetricsProvider);
    final geoAsync = ref.watch(travelGeoEnrichmentProvider);
    final tripsAsync = ref.watch(recentTripsProvider);
    final vizEngine = ref.watch(travelVizEngineProvider);

    return KnightPageScaffold(
      title: 'Command Center',
      showBackButton: true,
      body: Stack(
        children: [
          // 1. INTERACTIVE MAP
          _buildMap(geoAsync, tripsAsync, vizEngine),

          // 2. LIVE METRICS OVERLAY
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: SafeArea(
              child: EntranceFader(
                delay: const Duration(milliseconds: 200),
                child: Column(
                  children: [
                    _buildSearchTrigger(context, geoAsync),
                    const SizedBox(height: 12),
                    _buildMetricsOverlay(metricsAsync),
                  ],
                ),
              ),
            ),
          ),

          // 3. LAYER TOGGLE (Bottom Right)
          Positioned(
            bottom: 120,
            right: 16,
            child: EntranceFader(
              delay: const Duration(milliseconds: 400),
              offset: const Offset(20, 0),
              child: _buildLayerToggle(),
            ),
          ),

          // 4. LOCATION PREVIEW (Bottom)
          if (_selectedLocationId != null)
            Positioned(
              bottom: 100,
              left: 16,
              right: 16,
              child: EntranceFader(
                child: _buildLocationPreview(geoAsync),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchTrigger(BuildContext context, AsyncValue<List<TravelGeographicEnrichmentData>> geoAsync) {
    return GestureDetector(
      onTap: () async {
        final result = await showSearch(context: context, delegate: TravelSearchDelegate());
        if (result is TripData && mounted) {
          _navigateToTrip(result, geoAsync.value ?? []);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: KnightTokens.glass(accentColor: Colors.white, opacity: 0.15),
        child: const Row(
          children: [
            Icon(Icons.search, color: Colors.white38, size: 18),
            SizedBox(width: 12),
            Text('Search travel history...', style: TextStyle(color: Colors.white38, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  void _navigateToTrip(TripData trip, List<TravelGeographicEnrichmentData> locations) {
    // Attempt to find coordinates for the trip destination
    final normalizedTitle = trip.title.toLowerCase();
    final loc = locations.firstWhere(
      (l) => normalizedTitle.contains(l.placeId.toLowerCase()) || normalizedTitle.contains(l.city?.toLowerCase() ?? ''),
      orElse: () => locations.first, // Fallback
    );

    if (loc.latitude != null && loc.longitude != null) {
      _animatedMapMove(LatLng(loc.latitude!, loc.longitude!), 12);
      setState(() => _selectedLocationId = loc.placeId);
    }
  }

  Widget _buildMap(
    AsyncValue<List<TravelGeographicEnrichmentData>> geoAsync,
    AsyncValue<List<TripData>> tripsAsync,
    TravelVizEngine vizEngine,
  ) {
    return geoAsync.when(
      data: (locations) {
        final clusters = vizEngine.clusterMarkers(locations, _mapController.camera.zoom);
        final markers = _renderClusters(clusters, vizEngine);
        final polylines = _generatePolylines(tripsAsync, locations, vizEngine);

        return FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: const LatLng(20, 0),
            initialZoom: 2,
            minZoom: 2,
            maxZoom: 18,
            onTap: (_, _) => setState(() => _selectedLocationId = null),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
              subdomains: const ['a', 'b', 'c', 'd'],
            ),
            if (_enabledLayers.contains('trips'))
              PolylineLayer(polylines: polylines),
            MarkerLayer(markers: markers),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Map Error: $e')),
    );
  }

  List<Marker> _renderClusters(List<TravelCluster> clusters, TravelVizEngine vizEngine) {
    return clusters.map((cluster) {
      if (cluster.isSingle) {
        final loc = cluster.items.first;
        final isSelected = _selectedLocationId == loc.placeId;
        final color = vizEngine.getColorForType(loc.category ?? 'default');

        return Marker(
          point: cluster.center,
          width: isSelected ? 60 : 40,
          height: isSelected ? 60 : 40,
          child: GestureDetector(
            onTap: () {
              setState(() => _selectedLocationId = loc.placeId);
              _animatedMapMove(cluster.center, _mapController.camera.zoom > 10 ? _mapController.camera.zoom : 10);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: isSelected ? 2 : 1),
                boxShadow: isSelected ? [BoxShadow(color: color, blurRadius: 15)] : [],
              ),
              child: Icon(
                vizEngine.getIconForType(loc.category ?? 'default'),
                color: color,
                size: isSelected ? 24 : 16,
              ),
            ),
          ),
        );
      } else {
        // Cluster Marker
        return Marker(
          point: cluster.center,
          width: 50,
          height: 50,
          child: GestureDetector(
            onTap: () => _animatedMapMove(cluster.center, _mapController.camera.zoom + 2),
            child: Container(
              decoration: BoxDecoration(
                color: DesignColors.accentBlue.withValues(alpha: 0.4),
                shape: BoxShape.circle,
                border: Border.all(color: DesignColors.accentBlue, width: 2),
                boxShadow: [BoxShadow(color: DesignColors.accentBlue.withValues(alpha: 0.3), blurRadius: 10)],
              ),
              child: Center(
                child: Text(
                  '${cluster.items.length}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ),
          ),
        );
      }
    }).toList();
  }

  List<Polyline> _generatePolylines(
    AsyncValue<List<TripData>> tripsAsync,
    List<TravelGeographicEnrichmentData> locations,
    TravelVizEngine vizEngine,
  ) {
    if (tripsAsync.value == null) return [];
    
    final polylines = <Polyline>[];
    
    for (final trip in tripsAsync.value!) {
      // Logic: If trip title contains two known locations, link them.
      // High-end implementation would use booking origins/destinations.
      // For Milestone 2A, we'll simulate a few routes if data matches.
      
      final color = vizEngine.getColorForType(trip.primaryType);
      
      // Placeholder: Draw curved lines between random visited cities for visual impact
      if (locations.length >= 2) {
        polylines.add(Polyline(
          points: [
            LatLng(locations[0].latitude ?? 0, locations[0].longitude ?? 0),
            LatLng(locations[1].latitude ?? 0, locations[1].longitude ?? 0),
          ],
          color: color.withValues(alpha: 0.4),
          strokeWidth: 2,
        ));
      }
    }
    return polylines;
  }

  Widget _buildMetricsOverlay(AsyncValue<Map<String, double>> metricsAsync) {
    return metricsAsync.when(
      data: (metrics) => SizedBox(
        height: 60,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _MiniStat(label: 'TRIPS', value: '${metrics['total_trips']?.toInt() ?? 0}'),
            _MiniStat(label: 'FLIGHTS', value: '${metrics['total_flights']?.toInt() ?? 0}'),
            _MiniStat(label: 'COUNTRIES', value: '${metrics['countries_visited']?.toInt() ?? 0}'),
            _MiniStat(label: 'DISTANCE', value: '${(metrics['total_distance'] ?? 0).toInt()} km'),
          ],
        ),
      ),
      loading: () => const SizedBox.shrink(),
      error: (e, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildLayerToggle() {
    return Column(
      children: [
        _LayerButton(
          icon: Icons.layers_rounded,
          onTap: () => _showLayerPicker(),
        ),
        const SizedBox(height: 8),
        _LayerButton(
          icon: Icons.my_location_rounded,
          onTap: () => _mapController.move(LatLng(20, 0), 2),
        ),
      ],
    );
  }

  void _showLayerPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: DesignColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: DesignRadius.sheet),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('MAP LAYERS', style: KnightTokens.label),
              const SizedBox(height: 16),
              _LayerTile(
                label: 'Flights',
                icon: Icons.flight_takeoff_rounded,
                enabled: _enabledLayers.contains('flights'),
                onChanged: (v) => _toggleLayer('flights', setModalState),
              ),
              _LayerTile(
                label: 'Hotels',
                icon: Icons.bed_rounded,
                enabled: _enabledLayers.contains('hotels'),
                onChanged: (v) => _toggleLayer('hotels', setModalState),
              ),
              _LayerTile(
                label: 'Photos',
                icon: Icons.photo_library_rounded,
                enabled: _enabledLayers.contains('photos'),
                onChanged: (v) => _toggleLayer('photos', setModalState),
              ),
              _LayerTile(
                label: 'Recent Routes',
                icon: Icons.route_rounded,
                enabled: _enabledLayers.contains('trips'),
                onChanged: (v) => _toggleLayer('trips', setModalState),
              ),
              const Divider(color: Colors.white10),
              const Text('FILTERS', style: KnightTokens.label),
              const SizedBox(height: 12),
              _FilterChipGroup(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleLayer(String layer, Function setModalState) {
    setState(() {
      if (_enabledLayers.contains(layer)) {
        _enabledLayers.remove(layer);
      } else {
        _enabledLayers.add(layer);
      }
    });
    setModalState(() {});
  }

  Widget _buildLocationPreview(AsyncValue<List<TravelGeographicEnrichmentData>> geoAsync) {
    final loc = geoAsync.value?.firstWhere((l) => l.placeId == _selectedLocationId);
    if (loc == null) return const SizedBox.shrink();

    return Card(
      color: DesignColors.surfaceHigh,
      shape: RoundedRectangleBorder(borderRadius: KnightTokens.radiusCard),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: DesignColors.accentBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.location_on, color: DesignColors.accentBlue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(loc.placeId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 4),
                  Text('${loc.city ?? ''}, ${loc.country}', style: const TextStyle(fontSize: 12, color: Colors.white38)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _SmallBadge(label: '3 TRIPS', color: DesignColors.accentBlue),
                      const SizedBox(width: 8),
                      _SmallBadge(label: 'HIGH CONF', color: DesignColors.success),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: KnightTokens.radiusPill,
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(label, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: color)),
    );
  }
}

class _FilterChipGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        FilterChip(label: const Text('2026', style: TextStyle(fontSize: 10)), onSelected: (_) {}, backgroundColor: DesignColors.white05),
        FilterChip(label: const Text('Verified', style: TextStyle(fontSize: 10)), onSelected: (_) {}, backgroundColor: DesignColors.white05),
        FilterChip(label: const Text('High Confidence', style: TextStyle(fontSize: 10)), onSelected: (_) {}, backgroundColor: DesignColors.white05),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: KnightTokens.glass(accentColor: Colors.white, opacity: 0.15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
          Text(label, style: const TextStyle(fontSize: 8, color: Colors.white38, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _LayerButton extends StatelessWidget {
  const _LayerButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: DesignColors.surfaceHigh,
          shape: BoxShape.circle,
          boxShadow: DesignShadows.soft,
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Icon(icon, color: Colors.white70, size: 20),
      ),
    );
  }
}

class _LayerTile extends StatelessWidget {
  const _LayerTile({required this.label, required this.icon, required this.enabled, required this.onChanged});
  final String label;
  final IconData icon;
  final bool enabled;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: enabled ? DesignColors.accentBlue : Colors.white24),
      title: Text(label, style: TextStyle(color: enabled ? Colors.white : Colors.white24, fontSize: 14)),
      trailing: Switch(
        value: enabled,
        onChanged: onChanged,
        activeThumbColor: DesignColors.accentBlue,
      ),
    );
  }
}
