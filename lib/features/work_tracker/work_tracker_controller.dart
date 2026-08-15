import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/providers/storage_providers.dart';

import 'data/work_module_state.dart';
import 'data/work_storage.dart';
import 'domain/work_profile.dart';
import 'domain/work_session.dart';

final workSessionsProvider =
    AsyncNotifierProvider<WorkSessionsNotifier, List<WorkSession>>(
      WorkSessionsNotifier.new,
    );

final workModuleStateProvider =
    AsyncNotifierProvider<WorkModuleStateNotifier, WorkModuleState>(
      WorkModuleStateNotifier.new,
    );

class WorkSessionsNotifier extends AsyncNotifier<List<WorkSession>> {
  late final WorkStorage _storage;

  @override
  Future<List<WorkSession>> build() async {
    final engine = ref.watch(storageEngineProvider);
    _storage = WorkStorage(engine: engine);
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
    final engine = ref.watch(storageEngineProvider);
    _storage = WorkStorage(engine: engine);
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

  Future<void> startSession() async {
    state = await AsyncValue.guard(() async {
      final moduleState = await _storage.loadWorkModuleState();
      final updated = moduleState.copyWith(
        isWorking: true,
        activeSessionStartTime: DateTime.now(),
      );
      await _storage.saveWorkModuleState(updated);
      return updated;
    });
  }

  Future<void> stopSession() async {
    state = await AsyncValue.guard(() async {
      final moduleState = await _storage.loadWorkModuleState();
      if (!moduleState.isWorking || moduleState.activeSessionStartTime == null) return moduleState;

      final endTime = DateTime.now();
      final duration = endTime.difference(moduleState.activeSessionStartTime!).inMinutes;

      final session = WorkSession(
        id: 'session-${DateTime.now().millisecondsSinceEpoch}',
        workDate: DateFormat('yyyy-MM-dd').format(moduleState.activeSessionStartTime!),
        startTime: moduleState.activeSessionStartTime!.toIso8601String(),
        endTime: endTime.toIso8601String(),
        totalHours: duration / 60.0,
        productiveHours: duration / 60.0,
        focusRating: 8,
        shiftType: moduleState.profile.shiftType,
        questionsCompleted: 0,
        callsHandled: 0,
        chatsHandled: 0,
        breakDuration: 0,
        stressRating: 5,
        energyRating: 7,
        notes: '',
        callsPercentage: 0,
        chatsPercentage: 0,
        questionsPerHour: 0,
        weeklyAverage: 0,
        monthlyAverage: 0,
      );

      await _storage.saveSession(session);
      
      final updated = moduleState.copyWith(
        isWorking: false,
        activeSessionStartTime: null,
      );
      await _storage.saveWorkModuleState(updated);
      return updated;
    });
  }
}
