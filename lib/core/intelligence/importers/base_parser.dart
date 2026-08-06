import 'dart:io';

class ParsedData {
  const ParsedData({
    this.transactions = const [],
    this.healthMetrics = const [],
    this.timelineEvents = const [],
    this.careerEvents = const [],
  });

  final List<dynamic> transactions; // TransactionTableCompanion
  final List<dynamic> healthMetrics; // HealthMetricTableCompanion
  final List<dynamic> timelineEvents; // TimelineEventTableCompanion
  final List<dynamic> careerEvents; // ExtractedEntityTableCompanion
}

abstract class BaseParser {
  String get docType;
  int get version;
  
  Future<ParsedData> parse(File file);
}
