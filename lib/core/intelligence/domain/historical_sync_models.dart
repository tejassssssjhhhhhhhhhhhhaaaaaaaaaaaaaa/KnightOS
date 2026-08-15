import 'package:flutter/foundation.dart';

/// Represents the persistent state of a multi-year historical data crawl.
@immutable
class HistoricalSyncState {
  /// 'pending', 'in_progress', 'completed', 'failed'
  final String status;

  /// The beginning of the total historical window (e.g., 5 years ago).
  final DateTime? rangeStart;

  /// The end of the total historical window (usually 'now' at time of job creation).
  final DateTime? rangeEnd;

  /// The end timestamp of the last successfully processed batch.
  /// Used as the starting point for the next resumption.
  final DateTime? lastSuccessfulSliceEnd;

  /// Human-readable error if the job failed.
  final String? error;

  const HistoricalSyncState({
    required this.status,
    this.rangeStart,
    this.rangeEnd,
    this.lastSuccessfulSliceEnd,
    this.error,
  });

  bool get isCompleted => status == 'completed';
  bool get isInProgress => status == 'in_progress';
  bool get isFailed => status == 'failed';

  /// Returns the start of the next required slice.
  DateTime? get nextSliceStart => lastSuccessfulSliceEnd ?? rangeStart;

  /// Calculates the end of the next slice based on the provided window.
  DateTime? calculateNextSliceEnd(Duration window) {
    final start = nextSliceStart;
    final totalEnd = rangeEnd;
    if (start == null || totalEnd == null) return null;

    final nextEnd = start.add(window);
    return nextEnd.isAfter(totalEnd) ? totalEnd : nextEnd;
  }

  /// Percentage of the total range covered (0.0 to 1.0).
  double get progress {
    if (isCompleted) return 1.0;
    final start = rangeStart?.millisecondsSinceEpoch ?? 0;
    final end = rangeEnd?.millisecondsSinceEpoch ?? 0;
    final current = lastSuccessfulSliceEnd?.millisecondsSinceEpoch ?? start;

    if (end <= start) return 0.0;
    return ((current - start) / (end - start)).clamp(0.0, 1.0);
  }

  /// NOTE: Zero-result periods during a slice crawl must NOT automatically
  /// be classified as missing data. Future gap detection must identify them
  /// as 'potential gaps' unless corroborating evidence exists.
}

/// A specific temporal batch of historical work.
@immutable
class HistoricalSyncSlice {
  final DateTime start;
  final DateTime end;

  const HistoricalSyncSlice({required this.start, required this.end});

  @override
  String toString() => 'Slice(${start.toIso8601String()} -> ${end.toIso8601String()})';
}
