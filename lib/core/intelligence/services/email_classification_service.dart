import 'package:drift/drift.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../engines/parsers/email_classifier.dart';
import '../engines/parsers/finance_parser.dart';
import '../engines/parsers/travel_parser.dart';
import '../engines/parsers/shopping_parser.dart';
import '../engines/parsers/bill_parser.dart';
import '../engines/parsers/subscription_parser.dart';
import '../engines/parsers/promotion_parser.dart';
import '../engines/parsers/document_parser.dart';
import '../engines/parsers/personal_parser.dart';
import '../engines/parsers/calendar_parser.dart';
import '../engines/parsers/unknown_parser.dart';
import '../../internal/utils/knight_logger.dart';

class EmailClassificationService {
  EmailClassificationService({required this.db});
  final KnightDatabase db;

  final List<EmailClassifier> _classifiers = [
    FinanceClassifier(),
    TravelClassifier(),
    ShoppingClassifier(),
    BillClassifier(),
    SubscriptionClassifier(),
    PromotionClassifier(),
    DocumentClassifier(),
    PersonalClassifier(),
    CalendarClassifier(),
    UnknownClassifier(),
  ];

  Future<void> classifyEmail(String messageId) async {
    final message = await db.gmailMessageDao.getByMessageId(messageId);
    if (message == null) {
      KnightLogger.warn('[CLASSIFY] Message not found: $messageId');
      return;
    }

    KnightLogger.info('[CLASSIFY] Classifying message: ${message.subject}');

    ClassificationResult bestResult = const ClassificationResult(
      category: 'unknown',
      confidence: 0.0,
      reason: 'No matching classifier',
    );

    for (final classifier in _classifiers) {
      final result = await classifier.classify(message.subject, message.snippet);
      if (result.confidence > bestResult.confidence) {
        bestResult = result;
      }
      if (bestResult.confidence >= 0.95) break; // Early exit for high confidence
    }

    await db.emailClassificationDao.upsertClassification(EmailClassificationTableCompanion.insert(
      id: 'class-$messageId',
      messageId: messageId,
      category: bestResult.category,
      confidenceScore: Value(bestResult.confidence),
      confidenceReason: Value(bestResult.reason),
      classifierVersion: const Value('1.0.0'),
      verificationState: const Value('unverified'),
    ));

    KnightLogger.info('[CLASSIFY] Email $messageId marked as ${bestResult.category} (${(bestResult.confidence * 100).toStringAsFixed(1)}%)');
  }
}
