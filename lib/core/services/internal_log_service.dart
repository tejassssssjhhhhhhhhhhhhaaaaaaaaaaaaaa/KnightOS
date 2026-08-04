import 'dart:async';

class LogEntry {
  final DateTime timestamp;
  final String level;
  final String category;
  final String message;
  final String? error;

  LogEntry({
    required this.timestamp,
    required this.level,
    required this.category,
    required this.message,
    this.error,
  });
}

class InternalLogService {
  InternalLogService._();
  static final InternalLogService instance = InternalLogService._();

  final List<LogEntry> _logs = [];
  final StreamController<List<LogEntry>> _controller = StreamController<List<LogEntry>>.broadcast();

  Stream<List<LogEntry>> get logStream => _controller.stream;
  List<LogEntry> get logs => List.unmodifiable(_logs);

  void capture(String level, String category, String message, {Object? error}) {
    final entry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      category: category,
      message: message,
      error: error?.toString(),
    );

    _logs.insert(0, entry);
    if (_logs.length > 200) {
      _logs.removeLast();
    }
    _controller.add(_logs);
  }

  void clear() {
    _logs.clear();
    _controller.add(_logs);
  }
}
