import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/internal/storage/drift/knight_database.dart';

final knowledgeVaultControllerProvider = Provider<KnowledgeVaultController>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  return KnowledgeVaultController(db: db);
});

class KnowledgeVaultController {
  const KnowledgeVaultController({required this.db});
  final KnightDatabase db;

  Future<List<ImportHistoryData>> getImports() => db.importDao.getAllImports();
}
