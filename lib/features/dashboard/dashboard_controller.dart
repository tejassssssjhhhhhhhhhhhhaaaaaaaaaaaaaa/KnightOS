import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/storage_providers.dart';

import 'dashboard_models.dart';
import 'dashboard_repository.dart';

/// Provider for the [DashboardRepository].
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final engine = ref.watch(storageEngineProvider);
  return DashboardRepository(engine: engine);
});

/// Provider for the dashboard state notifier.
final dashboardProvider =
    AsyncNotifierProvider<DashboardNotifier, DashboardData>(
      DashboardNotifier.new,
    );

class DashboardNotifier extends AsyncNotifier<DashboardData> {
  @override
  Future<DashboardData> build() async {
    return _loadDashboardData();
  }

  Future<void> refreshDashboard() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadDashboardData());
  }

  Future<DashboardData> _loadDashboardData() async {
    final repository = ref.read(dashboardRepositoryProvider);
    return repository.loadDashboardData();
  }
}
