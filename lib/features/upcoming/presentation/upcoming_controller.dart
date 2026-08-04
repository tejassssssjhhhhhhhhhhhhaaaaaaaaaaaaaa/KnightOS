import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../data/memory_upcoming_repository.dart';
import '../domain/upcoming_item.dart';
import '../domain/upcoming_repository.dart';
import '../domain/upcoming_state.dart';

final upcomingRepositoryProvider = Provider<UpcomingRepository>((ref) {
  final memoryEngine = ref.watch(memoryEngineProvider);
  return MemoryUpcomingRepository(memoryEngine: memoryEngine);
});

final upcomingProvider =
    AsyncNotifierProvider<UpcomingController, UpcomingState>(
      UpcomingController.new,
    );

class UpcomingController extends AsyncNotifier<UpcomingState> {
  late final UpcomingRepository _repository;

  @override
  Future<UpcomingState> build() async {
    _repository = ref.watch(upcomingRepositoryProvider);
    final items = await _repository.getUpcomingItems();
    return UpcomingState(items: items);
  }

  Future<void> addItem(UpcomingItem item) async {
    state = AsyncValue.data(state.value!.copyWith(isLoading: true));
    await _repository.saveUpcomingItem(item);
    final items = await _repository.getUpcomingItems();
    state = AsyncValue.data(UpcomingState(items: items));
  }

  Future<void> updateItem(UpcomingItem item) async {
    await _repository.saveUpcomingItem(item);
    final items = await _repository.getUpcomingItems();
    state = AsyncValue.data(UpcomingState(items: items));
  }

  Future<void> completeItem(String id, bool completed) async {
    final items = state.value?.items ?? [];
    final item = items.firstWhereOrNull((e) => e.id == id);
    if (item != null) {
      await updateItem(item.copyWith(completed: completed));
    }
  }

  Future<void> deleteItem(String id) async {
    await _repository.deleteUpcomingItem(id);
    final items = await _repository.getUpcomingItems();
    state = AsyncValue.data(UpcomingState(items: items));
  }
}
