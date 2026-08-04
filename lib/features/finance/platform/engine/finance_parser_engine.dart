import '../interfaces/finance_parser.dart';
import '../models/extraction_result.dart';
import '../../../../core/internal/utils/knight_logger.dart';

class FinanceParserEngine implements IParserEngine {
  final List<IFinanceParser> _parsers = [];

  @override
  void registerParser(IFinanceParser parser) {
    _parsers.add(parser);
  }

  @override
  Map<String, String> get parserVersions {
    final versions = <String, String>{};
    for (final parser in _parsers) {
      versions[parser.institutionId] = parser.version;
    }
    return versions;
  }

  @override
  Future<ExtractionResult> process(
    String messageId,
    String sender,
    String subject,
    String body,
    DateTime timestamp,
  ) async {
    for (final parser in _parsers) {
      if (parser.canHandle(sender, subject, body)) {
        try {
          return await parser.parse(messageId, subject, body, timestamp);
        } catch (e) {
          KnightLogger.error('[FINANCE] Parser ${parser.institutionId} failed for message $messageId', error: e);
          // Continue to next parser or fallback
        }
      }
    }

    // Generic Fallback Extraction
    return ExtractionResult(
      messageId: messageId,
      parserVersion: 'generic-1.0.0',
      confidenceLevel: ConfidenceLevel.low,
      confidenceScore: 0.1,
      rawExtractedData: {'reason': 'no_matching_parser'},
    );
  }
}
