import 'package:drift/drift.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';
import '../interfaces/finance_classification.dart';

class FinanceClassificationEngine implements IFinanceClassificationEngine {
  FinanceClassificationEngine({required this.db});
  final KnightDatabase db;

  @override
  Future<FinanceCategory> classify(String subject, String body) async {
    final text = '$subject $body'.toLowerCase();

    if (text.contains('salary') || text.contains('pay slip')) return FinanceCategory.salary;
    if (text.contains('statement')) return FinanceCategory.statement;
    if (text.contains('emi') || text.contains('loan installment')) return FinanceCategory.emi;
    if (text.contains('loan')) return FinanceCategory.loan;
    if (text.contains('insurance') || text.contains('premium')) return FinanceCategory.insurance;
    if (text.contains('refund')) return FinanceCategory.refund;
    if (text.contains('investment') || text.contains('mutual fund')) return FinanceCategory.investment;
    if (text.contains('bill') || text.contains('utility')) return FinanceCategory.bill;
    if (text.contains('upi') || text.contains('vpa')) return FinanceCategory.upi;
    if (text.contains('credit card')) return FinanceCategory.creditCard;
    if (text.contains('debit card') || text.contains('atm withdrawal')) return FinanceCategory.debitCard;

    // Check if it's definitely non-financial (Promotions, etc.)
    if (text.contains('newsletter') || text.contains('offer') || text.contains('marketing')) {
      return FinanceCategory.nonFinancial;
    }

    return FinanceCategory.unknownFinancial;
  }

  /// Processes all discovered messages and updates their terminal intent in the journal.
  Future<void> classifyAll() async {
    final messages = await db.select(db.gmailMessageTable).get();
    
    for (final msg in messages) {
      final category = await classify(msg.subject, msg.snippet);
      
      // Update Sync Journal with terminal intent or next state
      await (db.update(db.financeSyncJournalTable)..where((t) => t.messageId.equals(msg.id))).write(
        FinanceSyncJournalTableCompanion(
          processingResult: Value(category == FinanceCategory.nonFinancial ? 'Non-Financial' : 'Classified'),
          errorLog: Value(category.name), // Store category name for tracking
        ),
      );

      // Store in EmailClassificationTable for audit
      await db.into(db.emailClassificationTable).insertOnConflictUpdate(
        EmailClassificationTableCompanion.insert(
          id: 'cls-${msg.id}',
          messageId: msg.id,
          category: category.name,
          confidenceScore: Value(0.9),
          verificationState: const Value('unverified'),
        ),
      );
    }
  }
}
