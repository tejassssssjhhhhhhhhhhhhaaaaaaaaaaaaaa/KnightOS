import '../storage/knight_entity.dart';

/// Contract for the OS-wide Unified Search.
abstract class SearchEngine {
  Future<List<KnightEntity>> search(String query);
}

/// Contract for the chronological Activity Timeline.
abstract class TimelineEngine {
  Stream<List<KnightEntity>> getActivityFeed();
}

/// Contract for local AI Context & Memory.
abstract class AIMemoryEngine {
  Future<void> remember(KnightEntity entity);
}

/// Contract for Multi-device Synchronization.
abstract class SyncEngine {
  Future<void> triggerSync();
  Stream<SyncStatus> get syncStatus;
}

enum SyncStatus { idle, pending, syncing, conflict, failed }
