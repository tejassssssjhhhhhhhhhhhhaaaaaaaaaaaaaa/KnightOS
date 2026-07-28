import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../data/memory_timeline_repository.dart';
import '../domain/timeline_entry.dart';
import '../domain/timeline_repository.dart';
import '../domain/timeline_state.dart';

final timelineRepositoryProvider = Provider<TimelineRepository>((ref) {
  final memoryEngine = ref.watch(memoryEngineProvider);
  return MemoryTimelineRepository(memoryEngine: memoryEngine);
});

final timelineProvider =
    AsyncNotifierProvider<TimelineController, TimelineState>(
      TimelineController.new,
    );

class TimelineController extends AsyncNotifier<TimelineState> {
  late final TimelineRepository _repository;

  @override
  Future<TimelineState> build() async {
    _repository = ref.watch(timelineRepositoryProvider);
    final entries = await _repository.getEntries();
    return TimelineState(entries: entries);
  }

  Future<void> addEntry(TimelineEntry entry) async {
    await _repository.saveEntry(entry);
    final entries = await _repository.getEntries();
    state = AsyncValue.data(TimelineState(entries: entries));
  }

  Future<void> updateEntry(TimelineEntry entry) async {
    await _repository.saveEntry(entry);
    final entries = await _repository.getEntries();
    state = AsyncValue.data(TimelineState(entries: entries));
  }

  Future<void> deleteEntry(String id) async {
    await _repository.deleteEntry(id);
    final entries = await _repository.getEntries();
    state = AsyncValue.data(TimelineState(entries: entries));
  }

  Future<void> toggleFavorite(String id) async {
    final entries = state.value?.entries ?? [];
    final index = entries.indexWhere((e) => e.id == id);
    if (index != -1) {
      final updatedEntry = entries[index].copyWith(
        favorite: !entries[index].favorite,
      );
      await updateEntry(updatedEntry);
    }
  }
}
