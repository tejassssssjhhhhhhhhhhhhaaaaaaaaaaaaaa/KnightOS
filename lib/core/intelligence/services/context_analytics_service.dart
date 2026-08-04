import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../providers/database_provider.dart';

class ContextAnalytics {
  final double averageHealthScore;
  final int totalSnapshots;
  final int historyCount;
  final Map<String, double> sourceContributionRatios;

  ContextAnalytics({
    required this.averageHealthScore,
    required this.totalSnapshots,
    required this.historyCount,
    this.sourceContributionRatios = const {},
  });
}

class ContextAnalyticsService {
  ContextAnalyticsService({required this.db});
  final KnightDatabase db;

  Future<ContextAnalytics> calculate() async {
    final avgHealthQuery = await db.customSelect('SELECT AVG(health_score) as avg FROM context_history').getSingle();
    final snapCountQuery = await db.customSelect('SELECT COUNT(*) as c FROM context_snapshots').getSingle();
    final historyCountQuery = await db.customSelect('SELECT COUNT(*) as c FROM context_history').getSingle();

    return ContextAnalytics(
      averageHealthScore: avgHealthQuery.read<double?>('avg') ?? 0.0,
      totalSnapshots: snapCountQuery.read<int>('c'),
      historyCount: historyCountQuery.read<int>('c'),
    );
  }
}

final contextAnalyticsServiceProvider = Provider<ContextAnalyticsService>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  return ContextAnalyticsService(db: db);
});
