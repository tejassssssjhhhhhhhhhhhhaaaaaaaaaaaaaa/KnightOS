import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/work_module_state.dart';
import 'data/work_storage.dart';
import 'domain/work_profile.dart';
import 'domain/work_session.dart';

final workSessionsProvider = AsyncNotifierProvider<WorkSessionsNotifier, List<WorkSession>>(
  WorkSessionsNotifier.new,
);

final workModuleStateProvider = AsyncNotifierProvider<WorkModuleStateNotifier, WorkModuleState>(
  WorkModuleStateNotifier.new,
);

class WorkSessionsNotifier extends AsyncNotifier<List<WorkSession>> {
  late final WorkStorage _storage;

  @override
  Future<List<WorkSession>> build() async {
    _storage = WorkStorage();
    final moduleState = await _storage.loadWorkModuleState();
    return moduleState.sessions;
  }

  Future<void> saveSession(WorkSession session) async {
    state = await AsyncValue.guard(() async {
      await _storage.saveSession(session);
      final moduleState = await _storage.loadWorkModuleState();
      return moduleState.sessions;
    });
  }

  Future<void> deleteSession(String id) async {
    state = await AsyncValue.guard(() async {
      await _storage.deleteSession(id);
      final moduleState = await _storage.loadWorkModuleState();
      return moduleState.sessions;
    });
  }
}

class WorkModuleStateNotifier extends AsyncNotifier<WorkModuleState> {
  late final WorkStorage _storage;

  @override
  Future<WorkModuleState> build() async {
    _storage = WorkStorage();
    return _storage.loadWorkModuleState();
  }

  Future<void> saveProfile(WorkProfile profile) async {
    state = await AsyncValue.guard(() async {
      final moduleState = await _storage.loadWorkModuleState();
      final updated = moduleState.copyWith(profile: profile);
      await _storage.saveWorkModuleState(updated);
      return updated;
    });
  }

  Future<void> saveDailyTarget(int target) async {
    state = await AsyncValue.guard(() async {
      final moduleState = await _storage.loadWorkModuleState();
      final updated = moduleState.copyWith(dailyTarget: target);
      await _storage.saveWorkModuleState(updated);
      return updated;
    });
  }

  Future<void> saveSession(WorkSession session) async {
    state = await AsyncValue.guard(() async {
      await _storage.saveSession(session);
      return _storage.loadWorkModuleState();
    });
  }

  Future<void> deleteSession(String id) async {
    state = await AsyncValue.guard(() async {
      await _storage.deleteSession(id);
      return _storage.loadWorkModuleState();
    });
  }
}
