import 'dart:io';

class ParsedData {
  const ParsedData({
    this.transactions = const [],
    this.healthMetrics = const [],
    this.timelineEvents = const [],
  });

  final List<dynamic> transactions; // TransactionTableCompanion
  final List<dynamic> healthMetrics; // HealthMetricTableCompanion
  final List<dynamic> timelineEvents; // TimelineEventTableCompanion
}

abstract class BaseParser {
  String get docType;
  int get version;
  
  Future<ParsedData> parse(File file);
}
