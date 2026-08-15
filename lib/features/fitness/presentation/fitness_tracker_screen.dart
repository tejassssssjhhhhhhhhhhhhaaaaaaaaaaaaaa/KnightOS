import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/design_system/knight_tokens.dart';
import '../../../core/platform/engine/analytics_models.dart';
import '../../../core/platform/engine/search_models.dart';
import '../data/fitness_engine_adapter.dart';
import '../data/fitness_module_state.dart';
import '../data/fitness_storage.dart';
import '../domain/equipment_catalog.dart';
import '../domain/gym_profile.dart';

class FitnessTrackerScreen extends StatefulWidget {
  const FitnessTrackerScreen({super.key});

  @override
  State<FitnessTrackerScreen> createState() => _FitnessTrackerScreenState();
}

class _FitnessTrackerScreenState extends State<FitnessTrackerScreen> {
  final FitnessStorage _storage = FitnessStorage();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _gymNameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  late FitnessModuleState _state;
  late FitnessFeatureModule _module;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _gymNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadState() async {
    final loadedState = await _storage.loadFitnessModuleState();
    if (!mounted) return;
    setState(() {
      _state = loadedState;
      _searchController.text = loadedState.searchQuery;
      _gymNameController.text = loadedState.gymProfile.name;
      _notesController.text = loadedState.gymProfile.notes;
      _module = FitnessFeatureModule(
        fitnessState: loadedState,
        catalog: FitnessEquipmentCatalog.items,
      );
      _isLoading = false;
    });
  }

  Future<void> _persistState() async {
    setState(() => _isSaving = true);
    await _storage.saveFitnessModuleState(_state);
    if (!mounted) return;
    setState(() => _isSaving = false);
  }

  Future<void> _toggleEquipment(String equipmentId) async {
    final nextIds = <String>{..._state.availableEquipmentIds};
    if (nextIds.contains(equipmentId)) {
      nextIds.remove(equipmentId);
    } else {
      nextIds.add(equipmentId);
    }

    final nextState = _state.copyWith(
      availableEquipmentIds: nextIds.toList()..sort(),
    );
    setState(() {
      _state = nextState;
      _module = FitnessFeatureModule(
        fitnessState: nextState,
        catalog: FitnessEquipmentCatalog.items,
      );
    });
    await _persistState();
  }

  Future<void> _updateGymProfile() async {
    final nextProfile = GymProfile(
      name: _gymNameController.text.trim(),
      type: _selectedGymType,
      notes: _notesController.text.trim(),
    );
    final nextState = _state.copyWith(gymProfile: nextProfile);
    setState(() {
      _state = nextState;
      _module = FitnessFeatureModule(
        fitnessState: nextState,
        catalog: FitnessEquipmentCatalog.items,
      );
    });
    await _persistState();
  }

  Future<void> _updateSearch(String value) async {
    final nextState = _state.copyWith(searchQuery: value);
    setState(() {
      _state = nextState;
      _module = FitnessFeatureModule(
        fitnessState: nextState,
        catalog: FitnessEquipmentCatalog.items,
      );
    });
    await _persistState();
  }

  GymProfileType get _selectedGymType => _state.gymProfile.type;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const KnightPageScaffold(
        title: 'Fitness',
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return KnightPageScaffold(
      title: 'Fitness',
      showBackButton: true,
      actions: [
        IconButton(
          onPressed: () => context.push(AppRoutes.profile), 
          icon: const Icon(Icons.tune_rounded, size: 20),
        ),
      ],
      body: RefreshIndicator(
        onRefresh: _loadState,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildActiveWorkoutCard(),
              const SizedBox(height: 24),
              _buildHistorySection(),
              const SizedBox(height: 32),
              _buildProfileCard(),
              const SizedBox(height: 24),
              _buildSearchCard(),
              const SizedBox(height: 24),
              _buildEquipmentSection(),
              const SizedBox(height: 24),
              _buildAnalyticsSection(),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _startNewWorkout(context),
        label: const Text('START WORKOUT', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        icon: const Icon(Icons.play_arrow_rounded),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Widget _buildActiveWorkoutCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent.withValues(alpha: 0.1), Colors.transparent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.fitness_center_rounded, color: Colors.blueAccent, size: 18),
              const SizedBox(width: 12),
              Text('READY FOR ACTION', style: KnightTokens.label.copyWith(color: Colors.blueAccent)),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Maintain your momentum.', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          const Text('Knight OS tracks your sets and reps for progressive overload.', style: TextStyle(color: Colors.white38, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildHistorySection() {
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         const Padding(
           padding: EdgeInsets.symmetric(horizontal: 4),
           child: Text('RECENT HISTORY', style: KnightTokens.label),
         ),
         const SizedBox(height: 16),
         // Future: Stream history from DB
         Container(
           padding: const EdgeInsets.all(20),
           decoration: BoxDecoration(
             color: Colors.white.withValues(alpha: 0.03),
             borderRadius: BorderRadius.circular(24),
           ),
           child: const Center(
             child: Text('No recent workouts. Time to lift.', style: TextStyle(color: Colors.white24, fontSize: 12)),
           ),
         ),
       ],
     );
  }

  void _startNewWorkout(BuildContext context) {
    // Navigate to logger
    // context.push(AppRoutes.workoutLogger);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('V1.0 Workout Logger initializing...')),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gym Profile',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _gymNameController,
              decoration: const InputDecoration(labelText: 'Gym name'),
              onChanged: (_) => _updateGymProfile(),
            ),
            const SizedBox(height: 12),
            SegmentedButton<GymProfileType>(
              segments: const <ButtonSegment<GymProfileType>>[
                ButtonSegment(
                  value: GymProfileType.home,
                  label: Text('Home'),
                  icon: Icon(Icons.home_outlined),
                ),
                ButtonSegment(
                  value: GymProfileType.commercial,
                  label: Text('Commercial'),
                  icon: Icon(Icons.business_outlined),
                ),
              ],
              selected: <GymProfileType>{_selectedGymType},
              onSelectionChanged: (selection) async {
                final nextProfile = GymProfile(
                  name: _gymNameController.text.trim(),
                  type: selection.first,
                  notes: _notesController.text.trim(),
                );
                final nextState = _state.copyWith(gymProfile: nextProfile);
                setState(() {
                  _state = nextState;
                  _module = FitnessFeatureModule(
                    fitnessState: nextState,
                    catalog: FitnessEquipmentCatalog.items,
                  );
                });
                await _persistState();
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Notes (optional)'),
              onChanged: (_) => _updateGymProfile(),
            ),
            const SizedBox(height: 12),
            if (_isSaving)
              const Text('Saving profile…')
            else
              FilledButton.icon(
                onPressed: _updateGymProfile,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Save profile'),
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
              'Equipment Search',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            SearchBar(
              controller: _searchController,
              hintText: 'Search equipment by name or category',
              leading: const Icon(Icons.search_outlined),
              onChanged: (value) async {
                await _updateSearch(value);
              },
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: FitnessEquipmentCategory.values.map((category) {
                final count = _module.searchProvider != null
                    ? (FitnessEquipmentCatalog.items
                          .where((equipment) => equipment.category == category)
                          .length)
                    : 0;
                return FilterChip(
                  label: Text('${category.label} ($count)'),
                  selected: false,
                  onSelected: (_) async {
                    await _updateSearch(category.label);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEquipmentSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Equipment Library',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  '${_state.availableEquipmentIds.length} available',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            FutureBuilder<KnightSearchPage>(
              future: _module.searchProvider!.search(
                KnightSearchQuery(
                  moduleId: 'fitness',
                  text: _state.searchQuery,
                  page: 0,
                  pageSize: 100,
                ),
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final items = snapshot.data?.items ?? <KnightSearchResult>[];
                if (items.isEmpty) {
                  return Text(
                    'No equipment matches your search yet.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  );
                }

                final grouped = <String, List<KnightSearchResult>>{};
                for (final item in items) {
                  final category = item.metadata['category'] ?? 'General';
                  grouped
                      .putIfAbsent(category, () => <KnightSearchResult>[])
                      .add(item);
                }

                return Column(
                  children: grouped.entries.map((entry) {
                    return ExpansionTile(
                      title: Text(entry.key),
                      subtitle: Text('${entry.value.length} item(s)'),
                      children: entry.value.map((result) {
                        final isSelected = _state.availableEquipmentIds
                            .contains(result.id);
                        return CheckboxListTile(
                          value: isSelected,
                          onChanged: (value) async {
                            await _toggleEquipment(result.id);
                          },
                          title: Text(result.title),
                          subtitle: Text(result.summary),
                          secondary: const Icon(Icons.fitness_center_outlined),
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      }).toList(),
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

  Widget _buildAnalyticsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Engine Analytics',
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
