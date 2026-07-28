import 'package:flutter/foundation.dart';
import 'timeline_entry.dart';

@immutable
class TimelineState {
  const TimelineState({required this.entries, this.isLoading = false});

  final List<TimelineEntry> entries;
  final bool isLoading;

  TimelineState copyWith({List<TimelineEntry>? entries, bool? isLoading}) {
    return TimelineState(
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
