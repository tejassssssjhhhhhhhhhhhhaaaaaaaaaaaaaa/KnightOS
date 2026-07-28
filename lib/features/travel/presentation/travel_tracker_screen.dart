import 'package:flutter/material.dart';

import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/platform/engine/analytics_models.dart';
import '../../../core/platform/engine/search_models.dart';
import '../data/travel_engine_adapter.dart';
import '../data/travel_module_state.dart';
import '../data/travel_storage.dart';
import '../domain/planned_trip.dart';
import '../domain/travel_place.dart';

class TravelTrackerScreen extends StatefulWidget {
  const TravelTrackerScreen({super.key});

  @override
  State<TravelTrackerScreen> createState() => _TravelTrackerScreenState();
}

class _TravelTrackerScreenState extends State<TravelTrackerScreen> {
  final TravelStorage _storage = TravelStorage();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _tripDestinationController =
      TextEditingController();
  final TextEditingController _tripMonthController = TextEditingController();
  final TextEditingController _tripBudgetController = TextEditingController();
  final TextEditingController _tripNotesController = TextEditingController();
  final TextEditingController _placeNameController = TextEditingController();
  final TextEditingController _placeCountryController = TextEditingController();
  final TextEditingController _placeStateController = TextEditingController();
  final TextEditingController _placeCityController = TextEditingController();
  final TextEditingController _placeDescriptionController =
      TextEditingController();
  final TextEditingController _placeNotesController = TextEditingController();

  late TravelModuleState _state;
  late TravelFeatureModule _module;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tripDestinationController.dispose();
    _tripMonthController.dispose();
    _tripBudgetController.dispose();
    _tripNotesController.dispose();
    _placeNameController.dispose();
    _placeCountryController.dispose();
    _placeStateController.dispose();
    _placeCityController.dispose();
    _placeDescriptionController.dispose();
    _placeNotesController.dispose();
    super.dispose();
  }

  Future<void> _loadState() async {
    final loadedState = await _storage.loadTravelModuleState();
    if (!mounted) return;
    setState(() {
      _state = loadedState;
      _searchController.text = loadedState.searchQuery;
      _module = TravelFeatureModule(state: loadedState);
      _isLoading = false;
    });
  }

  Future<void> _persistState() async {
    await _storage.saveTravelModuleState(_state);
  }

  Future<void> _updateSearch(String value) async {
    final nextState = _state.copyWith(searchQuery: value);
    setState(() {
      _state = nextState;
      _module = TravelFeatureModule(state: nextState);
    });
    await _persistState();
  }

  Future<void> _addPlace(TravelPlaceStatus status) async {
    final place = TravelPlace(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: _placeNameController.text.trim(),
      type: TravelPlaceType.touristPlace,
      country: _placeCountryController.text.trim(),
      state: _placeStateController.text.trim(),
      city: _placeCityController.text.trim(),
      description: _placeDescriptionController.text.trim(),
      status: status,
      notes: _placeNotesController.text.trim(),
    );

    final nextPlaces = <TravelPlace>[..._state.places, place];
    final nextState = _state.copyWith(places: nextPlaces);
    setState(() {
      _state = nextState;
      _module = TravelFeatureModule(state: nextState);
    });
    _placeNameController.clear();
    _placeCountryController.clear();
    _placeStateController.clear();
    _placeCityController.clear();
    _placeDescriptionController.clear();
    _placeNotesController.clear();
    await _persistState();
  }

  Future<void> _addTrip() async {
    final trip = PlannedTrip(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      destination: _tripDestinationController.text.trim(),
      tentativeMonthYear: _tripMonthController.text.trim(),
      estimatedBudget: _tripBudgetController.text.trim(),
      notes: _tripNotesController.text.trim(),
    );

    final nextTrips = <PlannedTrip>[..._state.plannedTrips, trip];
    final nextState = _state.copyWith(plannedTrips: nextTrips);
    setState(() {
      _state = nextState;
      _module = TravelFeatureModule(state: nextState);
    });
    _tripDestinationController.clear();
    _tripMonthController.clear();
    _tripBudgetController.clear();
    _tripNotesController.clear();
    await _persistState();
  }

  Future<void> _togglePlaceStatus(
    TravelPlace place,
    TravelPlaceStatus nextStatus,
  ) async {
    final updated = place.copyWith(status: nextStatus);
    final nextPlaces = _state.places
        .map((entry) => entry.id == place.id ? updated : entry)
        .toList();
    final nextState = _state.copyWith(places: nextPlaces);
    setState(() {
      _state = nextState;
      _module = TravelFeatureModule(state: nextState);
    });
    await _persistState();
  }

  Future<void> _updatePlaceDetails(
    TravelPlace place, {
    String? notes,
    double? rating,
    bool? isFavorite,
  }) async {
    final updated = place.copyWith(
      notes: notes ?? place.notes,
      rating: rating ?? place.rating,
      isFavorite: isFavorite ?? place.isFavorite,
    );
    final nextPlaces = _state.places
        .map((entry) => entry.id == place.id ? updated : entry)
        .toList();
    final nextState = _state.copyWith(places: nextPlaces);
    setState(() {
      _state = nextState;
      _module = TravelFeatureModule(state: nextState);
    });
    await _persistState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const KnightPageScaffold(
        title: 'Travel',
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return KnightPageScaffold(
      title: 'Travel',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMapCard(),
            const SizedBox(height: 20),
            _buildSearchCard(),
            const SizedBox(height: 20),
            _buildPlaceFormCard(),
            const SizedBox(height: 20),
            _buildPlacesSection(),
            const SizedBox(height: 20),
            _buildTripsSection(),
            const SizedBox(height: 20),
            _buildAnalyticsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMapCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Interactive Travel Map',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer,
                    Theme.of(context).colorScheme.secondaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: CustomPaint(painter: _WorldMapPainter()),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    top: 20,
                    child: Chip(label: Text('India ready')),
                  ),
                  Positioned(
                    right: 24,
                    top: 20,
                    child: Chip(label: Text('Nepal ready')),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Text(
                      'World map preview · expandable for future regions',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Place Search',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            SearchBar(
              controller: _searchController,
              hintText: 'Search country, state, city or tourist place',
              leading: const Icon(Icons.search_outlined),
              onChanged: (value) async {
                await _updateSearch(value);
              },
            ),
            const SizedBox(height: 12),
            FutureBuilder<KnightSearchPage>(
              future: _module.searchProvider!.search(
                KnightSearchQuery(
                  moduleId: 'travel',
                  text: _state.searchQuery,
                  page: 0,
                  pageSize: 20,
                ),
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final items = snapshot.data?.items ?? <KnightSearchResult>[];
                if (items.isEmpty) {
                  return Text(
                    'Start typing to discover places.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  );
                }
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: items
                      .take(6)
                      .map((item) => Chip(label: Text(item.title)))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceFormCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Capture a Place',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 220,
                  child: TextField(
                    controller: _placeNameController,
                    decoration: const InputDecoration(
                      labelText: 'Place / landmark',
                    ),
                  ),
                ),
                SizedBox(
                  width: 220,
                  child: TextField(
                    controller: _placeCountryController,
                    decoration: const InputDecoration(labelText: 'Country'),
                  ),
                ),
                SizedBox(
                  width: 220,
                  child: TextField(
                    controller: _placeStateController,
                    decoration: const InputDecoration(labelText: 'State'),
                  ),
                ),
                SizedBox(
                  width: 220,
                  child: TextField(
                    controller: _placeCityController,
                    decoration: const InputDecoration(labelText: 'City'),
                  ),
                ),
                SizedBox(
                  width: 220,
                  child: TextField(
                    controller: _placeDescriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                ),
                SizedBox(
                  width: 220,
                  child: TextField(
                    controller: _placeNotesController,
                    decoration: const InputDecoration(labelText: 'Notes'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: () => _addPlace(TravelPlaceStatus.visited),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Visited'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _addPlace(TravelPlaceStatus.wishlist),
                  icon: const Icon(Icons.favorite_border),
                  label: const Text('Wishlist'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _addPlace(TravelPlaceStatus.planned),
                  icon: const Icon(Icons.event_available_outlined),
                  label: const Text('Planned'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlacesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Places',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            if (_state.places.isEmpty)
              Text(
                'No places added yet.',
                style: Theme.of(context).textTheme.bodyMedium,
              )
            else
              ExpansionTile(
                title: Text('Saved places (${_state.places.length})'),
                children: _state.places.map((place) {
                  return Card(
                    child: ListTile(
                      title: Text(place.name),
                      subtitle: Text(
                        '${place.country} · ${place.state} · ${place.city}',
                      ),
                      trailing: Wrap(
                        spacing: 4,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.favorite_border),
                            onPressed: () => _updatePlaceDetails(
                              place,
                              isFavorite: !place.isFavorite,
                            ),
                          ),
                          PopupMenuButton<TravelPlaceStatus>(
                            onSelected: (status) =>
                                _togglePlaceStatus(place, status),
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: TravelPlaceStatus.visited,
                                child: Text('Visited'),
                              ),
                              PopupMenuItem(
                                value: TravelPlaceStatus.wishlist,
                                child: Text('Wishlist'),
                              ),
                              PopupMenuItem(
                                value: TravelPlaceStatus.planned,
                                child: Text('Planned'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Planned Trips',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 220,
                  child: TextField(
                    controller: _tripDestinationController,
                    decoration: const InputDecoration(labelText: 'Destination'),
                  ),
                ),
                SizedBox(
                  width: 220,
                  child: TextField(
                    controller: _tripMonthController,
                    decoration: const InputDecoration(
                      labelText: 'Tentative month/year',
                    ),
                  ),
                ),
                SizedBox(
                  width: 220,
                  child: TextField(
                    controller: _tripBudgetController,
                    decoration: const InputDecoration(
                      labelText: 'Estimated budget',
                    ),
                  ),
                ),
                SizedBox(
                  width: 220,
                  child: TextField(
                    controller: _tripNotesController,
                    decoration: const InputDecoration(labelText: 'Notes'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _addTrip,
              icon: const Icon(Icons.flight_takeoff_outlined),
              label: const Text('Save trip'),
            ),
            const SizedBox(height: 12),
            if (_state.plannedTrips.isEmpty)
              Text(
                'No trip plans yet.',
                style: Theme.of(context).textTheme.bodyMedium,
              )
            else
              ..._state.plannedTrips.map(
                (trip) => Card(
                  child: ListTile(
                    title: Text(trip.destination),
                    subtitle: Text(
                      '${trip.tentativeMonthYear} · ${trip.estimatedBudget} · ${trip.notes}',
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Travel Insights',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<KnightMetric>>(
              future: _module.analyticsProvider!.requestMetrics(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final metrics = snapshot.data ?? <KnightMetric>[];
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: metrics.map((metric) {
                    return SizedBox(
                      width: 180,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                metric.name,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                metric.value.toString(),
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _WorldMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(24, 40, size.width - 48, size.height - 80);
    canvas.drawRect(rect, paint);

    final indiaRect = Rect.fromLTWH(
      size.width * 0.66,
      size.height * 0.62,
      40,
      28,
    );
    final nepalRect = Rect.fromLTWH(
      size.width * 0.69,
      size.height * 0.58,
      26,
      18,
    );
    final worldRect = Rect.fromLTWH(
      size.width * 0.1,
      size.height * 0.2,
      size.width * 0.2,
      size.height * 0.3,
    );
    canvas.drawRect(
      indiaRect,
      Paint()
        ..color = Colors.deepPurple.shade700
        ..style = PaintingStyle.fill,
    );
    canvas.drawRect(
      nepalRect,
      Paint()
        ..color = Colors.indigo.shade700
        ..style = PaintingStyle.fill,
    );
    canvas.drawRect(
      worldRect,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.7)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
