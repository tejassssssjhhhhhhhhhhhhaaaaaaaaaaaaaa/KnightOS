import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dashboard_models.dart';
import 'dashboard_repository.dart';

final dashboardProvider = AsyncNotifierProvider<DashboardNotifier, DashboardData>(
  DashboardNotifier.new,
);

class DashboardNotifier extends AsyncNotifier<DashboardData> {
  late final DashboardRepository _repository;

  @override
  Future<DashboardData> build() async {
    _repository = DashboardRepository();
    return _loadDashboardData();
  }

  Future<void> refreshDashboard() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadDashboardData());
  }

  Future<DashboardData> _loadDashboardData() async {
    return _repository.loadDashboardData();
  }
}
