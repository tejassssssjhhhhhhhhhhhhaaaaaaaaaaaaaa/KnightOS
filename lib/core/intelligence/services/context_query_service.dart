import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../providers/database_provider.dart';

/// Provides access to historical context data and analytics.
class ContextQueryService {
  ContextQueryService({required this.db});
  final KnightDatabase db;

  /// Fetches context history within a time range.
  Future<List<ContextHistoryData>> getHistory(DateTime start, DateTime end) {
    return (db.select(db.contextHistoryTable)
          ..where((t) => t.timestamp.isBetweenValues(start, end))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .get();
  }

  /// Retrieves a specific snapshot by name.
  Future<ContextSnapshotData?> getSnapshot(String name) {
    return (db.select(db.contextSnapshotsTable)
          ..where((t) => t.name.equals(name))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Calculates context analytics (e.g., average health score).
  Future<Map<String, dynamic>> getAnalytics() async {
    final query = await db.customSelect('SELECT AVG(health_score) as avg_health FROM context_history').getSingle();
    return {
      'average_health': query.read<double>('avg_health'),
    };
  }
}

final contextQueryServiceProvider = Provider<ContextQueryService>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  return ContextQueryService(db: db);
});
