import 'dart:async';

enum TravelEventType {
  evidenceImported,
  tripCreated,
  tripUpdated,
  tripRepaired,
  confidenceUpdated,
  metricsRecalculated,
  syncStarted,
  syncCompleted,
  syncFailed
}

class TravelEvent {
  final TravelEventType type;
  final String? resourceId;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  TravelEvent({
    required this.type,
    this.resourceId,
    this.data = const {},
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

/// Decoupled event bus for travel-specific intelligence signals.
class TravelEventBus {
  final _controller = StreamController<TravelEvent>.broadcast();

  Stream<TravelEvent> get events => _controller.stream;

  /// Publishes a new event to the bus.
  void publish(TravelEvent event) {
    _controller.add(event);
  }

  /// Disposes the event bus.
  void dispose() {
    _controller.close();
  }
}
