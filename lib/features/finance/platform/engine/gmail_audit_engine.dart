import '../../../../core/internal/storage/drift/knight_database.dart';

class GmailAuditEngine {
  GmailAuditEngine({required this.db});
  final KnightDatabase db;

  Future<Map<String, dynamic>> generateAuditReport() async {
    final messages = await db.select(db.gmailMessageTable).get();
    final journalEntries = await db.select(db.financeSyncJournalTable).get();

    final parsed = journalEntries.where((e) => e.processingResult == 'Parsed').length;
    final needsReview = journalEntries.where((e) => e.processingResult == 'Needs Review').length;
    final unsupported = journalEntries.where((e) => e.processingResult == 'Unsupported').length;
    final nonFinancial = journalEntries.where((e) => e.processingResult == 'Non-Financial').length;
    
    final institutions = await db.select(db.financeInstitutionMetadataTable).get();

    DateTime? oldest;
    DateTime? newest;
    
    if (messages.isNotEmpty) {
      oldest = messages.map((m) => m.messageDate).reduce((a, b) => a.isBefore(b) ? a : b);
      newest = messages.map((m) => m.messageDate).reduce((a, b) => a.isAfter(b) ? a : b);
    }

    return {
      'total_gmail_messages': messages.length,
      'financial_emails_found': journalEntries.length - nonFinancial,
      'parsed_successfully': parsed,
      'needs_review': needsReview,
      'unsupported': unsupported,
      'non_financial': nonFinancial,
      'institutions_found': institutions.length,
      'oldest_financial_email': oldest?.toIso8601String(),
      'newest_financial_email': newest?.toIso8601String(),
      'parser_success_rate': journalEntries.isEmpty ? 0.0 : (parsed / journalEntries.length),
      'coverage_by_year': _generateCoverageByYear(messages),
    };
  }

  Map<int, int> _generateCoverageByYear(List<GmailMessageData> messages) {
    final coverage = <int, int>{};
    for (final msg in messages) {
      final year = msg.messageDate.year;
      coverage[year] = (coverage[year] ?? 0) + 1;
    }
    return coverage;
  }
}
