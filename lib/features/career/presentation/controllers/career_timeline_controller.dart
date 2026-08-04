import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/entities/timeline_event.dart';
import '../../../../core/providers/integration_providers.dart';

class CareerTimelineState {
  const CareerTimelineState({
    this.events = const [],
    this.filteredEvents = const [],
    this.searchQuery = '',
    this.selectedTypes = const {},
  });

  final List<TimelineEvent> events;
  final List<TimelineEvent> filteredEvents;
  final String searchQuery;
  final Set<TimelineEventType> selectedTypes;

  CareerTimelineState copyWith({
    List<TimelineEvent>? events,
    List<TimelineEvent>? filteredEvents,
    String? searchQuery,
    Set<TimelineEventType>? selectedTypes,
  }) {
    return CareerTimelineState(
      events: events ?? this.events,
      filteredEvents: filteredEvents ?? this.filteredEvents,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedTypes: selectedTypes ?? this.selectedTypes,
    );
  }
}

class CareerTimelineNotifier extends AsyncNotifier<CareerTimelineState> {
  @override
  Future<CareerTimelineState> build() async {
    final timelineService = ref.watch(timelineServiceProvider);
    final allEvents = await timelineService.getRecent(100);
    
    final careerTypes = {
      TimelineEventType.education,
      TimelineEventType.internship,
      TimelineEventType.employment,
      TimelineEventType.promotion,
      TimelineEventType.salaryMilestone,
      TimelineEventType.certification,
      TimelineEventType.project,
      TimelineEventType.award,
      TimelineEventType.performanceReview,
      TimelineEventType.meeting,
    };

    final careerEvents = allEvents.where((e) => careerTypes.contains(e.type)).toList();
    
    return CareerTimelineState(
      events: careerEvents,
      filteredEvents: careerEvents,
      selectedTypes: careerTypes,
    );
  }

  void filter(String query) {
    final currentState = state.value;
    if (currentState == null) return;
    
    final filtered = currentState.events.where((e) {
      final matchesQuery = e.title.toLowerCase().contains(query.toLowerCase()) || 
                          (e.location?.toLowerCase().contains(query.toLowerCase()) ?? false);
      final matchesType = currentState.selectedTypes.isEmpty || currentState.selectedTypes.contains(e.type);
      return matchesQuery && matchesType;
    }).toList();

    state = AsyncValue.data(currentState.copyWith(
      filteredEvents: filtered,
      searchQuery: query,
    ));
  }

  void toggleType(TimelineEventType type) {
    final currentState = state.value;
    if (currentState == null) return;
    
    final newTypes = Set<TimelineEventType>.from(currentState.selectedTypes);
    if (newTypes.contains(type)) {
      newTypes.remove(type);
    } else {
      newTypes.add(type);
    }

    state = AsyncValue.data(currentState.copyWith(selectedTypes: newTypes));
    filter(currentState.searchQuery);
  }
}

final careerTimelineControllerProvider = AsyncNotifierProvider<CareerTimelineNotifier, CareerTimelineState>(
  CareerTimelineNotifier.new,
);
