import 'dart:io';
import '../internal/storage/drift/knight_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class SystemStats {
  final int totalFiles;
  final int totalRecords;
  final double storageSizeMb;
  final int graphNodes;
  final int graphEdges;

  SystemStats({
    required this.totalFiles,
    required this.totalRecords,
    required this.storageSizeMb,
    required this.graphNodes,
    required this.graphEdges,
  });
}

class SystemIntegrityRepository {
  final KnightDatabase db;
  SystemIntegrityRepository({required this.db});

  Future<SystemStats> getStats() async {
    // 1. Total Imports
    final imports = await db.importDao.getAllImports();
    
    // 2. Records
    final txCount = await db.customSelect('SELECT COUNT(*) as c FROM transactions').getSingle().then((r) => r.read<int>('c'));
    final healthCount = await db.customSelect('SELECT COUNT(*) as c FROM health_metrics').getSingle().then((r) => r.read<int>('c'));
    final timelineCount = await db.customSelect('SELECT COUNT(*) as c FROM timeline_events').getSingle().then((r) => r.read<int>('c'));
    
    // 3. Storage Size
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(dbFolder.path, 'knight_os_v2.sqlite'));
    double sizeMb = 0;
    if (await dbFile.exists()) {
       sizeMb = (await dbFile.length()) / (1024 * 1024);
    }

    // 4. Graph Stats
    final totalNodes = await db.customSelect('SELECT COUNT(*) as c FROM graph_nodes').getSingle().then((r) => r.read<int>('c'));
    final totalEdges = await db.customSelect('SELECT COUNT(*) as c FROM graph_edges').getSingle().then((r) => r.read<int>('c'));

    return SystemStats(
      totalFiles: imports.length,
      totalRecords: txCount + healthCount + timelineCount,
      storageSizeMb: sizeMb,
      graphNodes: totalNodes,
      graphEdges: totalEdges,
    );
  }
}
