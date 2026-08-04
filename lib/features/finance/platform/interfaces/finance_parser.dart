import '../models/extraction_result.dart';

enum ConfidenceLevel { high, medium, low }

abstract class IFinanceParser {
  String get institutionId;
  String get version;
  
  bool canHandle(String sender, String subject, String body);
  
  Future<ExtractionResult> parse(String messageId, String subject, String body, DateTime timestamp);
}

abstract class IParserEngine {
  Future<ExtractionResult> process(String messageId, String sender, String subject, String body, DateTime timestamp);
  void registerParser(IFinanceParser parser);
  Map<String, String> get parserVersions;
}
