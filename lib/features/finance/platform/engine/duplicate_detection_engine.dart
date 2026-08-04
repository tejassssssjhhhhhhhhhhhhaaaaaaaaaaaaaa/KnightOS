import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';

class DuplicateDetectionEngine {
  /// Generates a fingerprint for a transaction evidence.
  static String generateFingerprint({
    required double amount,
    required DateTime date,
    String? referenceNumber,
    String? merchant,
    String? institution,
  }) {
    // We prioritize reference number if available
    final buffer = StringBuffer();
    buffer.write(amount.toStringAsFixed(2));
    buffer.write(date.year);
    buffer.write(date.month);
    buffer.write(date.day);
    
    if (referenceNumber != null && referenceNumber.isNotEmpty) {
      buffer.write(referenceNumber.toLowerCase());
    } else {
      // If no ref number, use merchant and institution to narrow down
      buffer.write(merchant?.toLowerCase() ?? 'unknown_merchant');
      buffer.write(institution?.toLowerCase() ?? 'unknown_institution');
    }

    return sha256.convert(utf8.encode(buffer.toString())).toString();
  }

  /// Calculates merge confidence between two pieces of evidence.
  static double calculateMergeConfidence(FinanceExtractionData a, FinanceExtractionData b) {
    if (a.referenceNumber != null && a.referenceNumber == b.referenceNumber) {
      return 1.0; // Same ref number -> 100% confidence
    }
    
    int matches = 0;
    if (a.amount == b.amount) {
      matches++;
    }
    if (a.merchant == b.merchant) {
      matches++;
    }
    if (a.institution == b.institution) {
      matches++;
    }
    if (a.messageDate.year == b.messageDate.year && 
        a.messageDate.month == b.messageDate.month && 
        a.messageDate.day == b.messageDate.day) {
      matches++;
    }

    return matches / 4.0;
  }
}

extension on FinanceExtractionData {
  DateTime get messageDate => extractionTimestamp; // Fallback or use a better field if available
}
