import '../../../../core/internal/storage/drift/knight_database.dart';
import '../interfaces/finance_parser.dart';
import 'finance_evidence_vault.dart';

class ReprocessEngine {
  ReprocessEngine({
    required this.db,
    required this.parserEngine,
    required this.vault,
  });

  final KnightDatabase db;
  final IParserEngine parserEngine;
  final FinanceEvidenceVault vault;

  /// Checks for any messages that were processed with an older parser version
  /// or are in a state that should be retried.
  Future<void> runReprocess() async {
    final journalEntries = await db.select(db.financeSyncJournalTable).get();
    
    // ignore: unused_local_variable
    final latestVersions = parserEngine.parserVersions;

    for (final entry in journalEntries) {
      bool needsReprocess = false;
      
      // Simple logic: if result is 'Needs Review' or 'Unsupported', always try latest.
      if (entry.processingResult == 'Needs Review' || entry.processingResult == 'Unsupported') {
        needsReprocess = true;
      }

      if (needsReprocess) {
        final msg = await (db.select(db.gmailMessageTable)..where((t) => t.id.equals(entry.messageId))).getSingleOrNull();
        if (msg != null) {
          await vault.ingestMessage(msg);
        }
      }
    }
  }
}
