import 'package:drift/drift.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';

class FinanceInboxService {
  FinanceInboxService({required this.db, required this.dao});

  final KnightDatabase db;
  final FinancePlatformDao dao;

  Stream<List<FinanceInboxTaskData>> watchPendingTasks() {
    return (db.select(db.financeInboxTaskTable)
          ..where((t) => t.status.equals('pending')))
        .watch();
  }

  Future<void> resolveTask(String taskId, String resolution) async {
    await (db.update(db.financeInboxTaskTable)
          ..where((t) => t.id.equals(taskId)))
        .write(FinanceInboxTaskTableCompanion(
      status: const Value('completed'),
      resolution: Value(resolution),
      resolvedAt: Value(DateTime.now()),
    ));
  }

  Future<Map<String, dynamic>> getTaskContext(String messageId) async {
    final message = await (db.select(db.gmailMessageTable)
          ..where((t) => t.id.equals(messageId)))
        .getSingleOrNull();
    
    final extraction = await dao.getExtractionsForMessage(messageId);
    
    return {
      'message': message,
      'extractions': extraction,
    };
  }
}
