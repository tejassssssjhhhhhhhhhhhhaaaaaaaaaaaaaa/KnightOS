import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../data/memory_focus_repository.dart';
import '../domain/focus_area.dart';
import '../domain/focus_repository.dart';

/// Provider for the [FocusRepository] implementation.
final focusRepositoryProvider = Provider<FocusRepository>((ref) {
  final memoryEngine = ref.watch(memoryEngineProvider);
  return MemoryFocusRepository(memoryEngine: memoryEngine);
});

/// Provider for the list of focus areas with their live state.
final focusAreasProvider =
    AsyncNotifierProvider<FocusController, List<FocusArea>>(
      FocusController.new,
    );

/// Controller for managing the "Today's Focus" state, backed by persistence.
class FocusController extends AsyncNotifier<List<FocusArea>> {
  late final FocusRepository _repository;

  @override
  Future<List<FocusArea>> build() async {
    _repository = ref.watch(focusRepositoryProvider);
    return _repository.getFocusAreas();
  }

  /// Refreshes the focus areas from the repository.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getFocusAreas());
  }

  /// Updates the progress for a specific focus category.
  Future<void> updateProgress(FocusCategory category, double progress) async {
    final currentAreas = state.value;
    if (currentAreas == null) return;

    final updatedList = [
      for (final area in currentAreas)
        if (area.category == category)
          area.copyWith(
            completionProgress: progress.clamp(0.0, 1.0),
            lastUpdated: DateTime.now(),
          )
        else
          area,
    ];

    state = AsyncValue.data(updatedList);

    final updatedArea = updatedList.firstWhere((e) => e.category == category);
    await _repository.updateFocusArea(updatedArea);
  }

  /// Updates the status badge for a specific focus category.
  Future<void> updateStatus(FocusCategory category, String? status) async {
    final currentAreas = state.value;
    if (currentAreas == null) return;

    final updatedList = [
      for (final area in currentAreas)
        if (area.category == category)
          area.copyWith(statusBadge: status, lastUpdated: DateTime.now())
        else
          area,
    ];

    state = AsyncValue.data(updatedList);

    final updatedArea = updatedList.firstWhere((e) => e.category == category);
    await _repository.updateFocusArea(updatedArea);
  }
}
