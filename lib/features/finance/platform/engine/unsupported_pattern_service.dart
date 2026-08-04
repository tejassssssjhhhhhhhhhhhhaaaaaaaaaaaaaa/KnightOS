import 'package:drift/drift.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';

class UnsupportedPatternService {
  UnsupportedPatternService({required this.db});
  final KnightDatabase db;

  /// Stores a financial email that cannot yet be classified or parsed.
  Future<void> queueUnsupported(String messageId, String reason) async {
    await (db.update(db.financeSyncJournalTable)..where((t) => t.messageId.equals(messageId))).write(
      FinanceSyncJournalTableCompanion(
        processingResult: const Value('Unsupported'),
        errorLog: Value(reason),
      ),
    );
    
    // Also create a task in Finance Inbox
    await db.into(db.financeInboxTaskTable).insert(
      FinanceInboxTaskTableCompanion.insert(
        id: 'unsupported-$messageId',
        taskType: 'Unsupported Format',
        messageId: Value(messageId),
        status: const Value('pending'),
      ),
    );
  }
}
