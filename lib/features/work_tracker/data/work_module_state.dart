import 'package:flutter/foundation.dart';

import '../domain/work_profile.dart';
import '../domain/work_session.dart';

@immutable
class WorkModuleState {
  const WorkModuleState({
    required this.profile,
    required this.sessions,
    required this.dailyTarget,
    required this.searchQuery,
  });

  final WorkProfile profile;
  final List<WorkSession> sessions;
  final int dailyTarget;
  final String searchQuery;

  factory WorkModuleState.initial() => WorkModuleState(
        profile: WorkProfile.empty(),
        sessions: const <WorkSession>[],
        dailyTarget: 0,
        searchQuery: '',
      );

  WorkModuleState copyWith({
    WorkProfile? profile,
    List<WorkSession>? sessions,
    int? dailyTarget,
    String? searchQuery,
  }) {
    return WorkModuleState(
      profile: profile ?? this.profile,
      sessions: sessions ?? this.sessions,
      dailyTarget: dailyTarget ?? this.dailyTarget,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'profile': profile.toJson(),
      'sessions': sessions.map((session) => session.toJson()).toList(growable: false),
      'dailyTarget': dailyTarget,
      'searchQuery': searchQuery,
    };
  }

  factory WorkModuleState.fromJson(Map<String, Object?> json) {
    final sessionsJson = json['sessions'] as List<Object?>?;
    return WorkModuleState(
      profile: json['profile'] is Map<String, Object?>
          ? WorkProfile.fromJson(json['profile'] as Map<String, Object?>)
          : WorkProfile.empty(),
      sessions: sessionsJson == null
          ? <WorkSession>[]
          : sessionsJson
              .whereType<Map<String, Object?>>()
              .map(WorkSession.fromJson)
              .toList(growable: false),
      dailyTarget: json['dailyTarget'] as int? ?? 0,
      searchQuery: json['searchQuery'] as String? ?? '',
    );
  }
}
