import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/mission_service.dart';
import '../services/event_bus.dart';
import '../intelligence/providers/intelligence_providers.dart';
import '../repositories/mission_repository_impl.dart';
import 'database_provider.dart';

final missionRepositoryProvider = Provider((ref) {
  final db = ref.watch(knightDatabaseProvider);
  return MissionRepositoryImpl(db.missionDao);
});

final missionServiceProvider = Provider((ref) {
  return MissionService(
    ref.watch(missionRepositoryProvider),
    eventBus: EventBus.instance,
  );
});
