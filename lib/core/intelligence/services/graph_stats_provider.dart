import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/database_provider.dart';

class GraphStats {
  final int totalNodes;
  final int totalEdges;
  final int canonicalNodes;
  final double averageTrust;
  final Map<String, int> typeDistribution;

  GraphStats({
    required this.totalNodes,
    required this.totalEdges,
    required this.canonicalNodes,
    required this.averageTrust,
    required this.typeDistribution,
  });
}

final graphStatsProvider = StreamProvider<GraphStats>((ref) async* {
  final db = ref.watch(knightDatabaseProvider);
  
  // Watch both nodes and edges
  final nodeStream = db.select(db.graphNodeTable).watch();
  
  yield* nodeStream.asyncMap((_) async {
    final nodes = await db.customSelect("SELECT COUNT(*) as c FROM graph_nodes").getSingle();
    final edges = await db.customSelect("SELECT COUNT(*) as c FROM graph_edges").getSingle();
    final canonical = await db.customSelect("SELECT COUNT(*) as c FROM graph_nodes WHERE is_canonical = 1").getSingle();
    final trust = await db.customSelect("SELECT AVG(trust_score) as a FROM graph_nodes").getSingle();
    
    final distQuery = await db.customSelect("SELECT type, COUNT(*) as c FROM graph_nodes GROUP BY type").get();
    final dist = <String, int>{};
    for (final row in distQuery) {
      dist[row.read<String>('type')] = row.read<int>('c');
    }

    return GraphStats(
      totalNodes: nodes.read<int>('c'),
      totalEdges: edges.read<int>('c'),
      canonicalNodes: canonical.read<int>('c'),
      averageTrust: trust.read<double?>('a') ?? 0.0,
      typeDistribution: dist,
    );
  });
});
