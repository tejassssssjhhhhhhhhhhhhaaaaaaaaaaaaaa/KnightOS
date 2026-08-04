import 'package:drift/drift.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';
import '../../../../core/internal/utils/knight_logger.dart';

class InstitutionDiscoveryEngine {
  InstitutionDiscoveryEngine({required this.db});
  final KnightDatabase db;

  /// Scans all discovered Gmail messages to identify financial institutions.
  Future<void> discoverInstitutions() async {
    KnightLogger.info('[FINANCE] Starting Institution Discovery');
    
    final messages = await db.select(db.gmailMessageTable).get();
    
    for (final msg in messages) {
      final institutionName = _extractInstitutionName(msg.sender, msg.subject);
      if (institutionName != null) {
        await db.into(db.financeInstitutionMetadataTable).insertOnConflictUpdate(
          FinanceInstitutionMetadataTableCompanion.insert(
            id: _generateId(institutionName),
            name: institutionName,
            type: _inferType(institutionName),
            rawMetadata: Value('Source: ${msg.sender}'),
          ),
        );
      }
    }
  }

  String? _extractInstitutionName(String sender, String subject) {
    final text = '$sender $subject'.toLowerCase();
    
    // Normalized map of common Indian financial institutions
    final institutions = {
      'hdfc': 'HDFC Bank',
      'icici': 'ICICI Bank',
      'sbi': 'State Bank of India',
      'axis': 'Axis Bank',
      'kotak': 'Kotak Mahindra Bank',
      'amex': 'American Express',
      'citibank': 'Citibank',
      'zerodha': 'Zerodha',
      'epfo': 'EPFO',
      'lic': 'LIC',
      'paytm': 'Paytm',
      'phonepe': 'PhonePe',
      'cred': 'CRED',
    };

    for (final entry in institutions.entries) {
      if (text.contains(entry.key)) return entry.value;
    }

    // Generic fallback for bank domains if not matched
    if (sender.contains('bank') || sender.contains('alerts')) {
       final domainMatch = RegExp(r'@([a-z0-9]+\.[a-z]+)').firstMatch(sender);
       if (domainMatch != null) {
         return domainMatch.group(1)?.toUpperCase();
       }
    }

    return null;
  }

  String _inferType(String name) {
    final n = name.toLowerCase();
    if (n.contains('bank')) return 'Bank';
    if (n.contains('express') || n.contains('card')) return 'Credit Card';
    if (n.contains('epfo')) return 'EPFO';
    if (n.contains('lic') || n.contains('insurance')) return 'Insurance';
    if (n.contains('zerodha') || n.contains('investment')) return 'Investment';
    return 'Other';
  }

  String _generateId(String name) {
    return name.toLowerCase().replaceAll(' ', '_');
  }
}
