enum ImportStatus { pending, processing, completed, failed, cancelled }

class ImportJob {
  const ImportJob({
    required this.id,
    required this.sourceId,
    required this.status,
    required this.progress,
    required this.startedAt,
    this.completedAt,
    this.error,
    this.processedCount = 0,
    this.totalCount = 0,
  });

  final String id;
  final String sourceId;
  final ImportStatus status;
  final double progress; // 0.0 to 1.0
  final DateTime startedAt;
  final DateTime? completedAt;
  final String? error;
  final int processedCount;
  final int totalCount;
}

class ImportResult {
  const ImportResult({
    required this.success,
    this.message,
    this.timelineEvents = const [],
    this.documents = const [],
    this.transactions = const [],
    this.people = const [],
    this.places = const [],
  });

  final bool success;
  final String? message;
  final List<dynamic> timelineEvents;
  final List<dynamic> documents;
  final List<dynamic> transactions;
  final List<dynamic> people;
  final List<dynamic> places;
}
