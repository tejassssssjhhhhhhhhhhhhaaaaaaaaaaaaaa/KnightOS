import 'dart:async';
import 'domain/intelligence_events.dart';

/// Central event-dispatching hub for the Knight Intelligence Platform.
class IntelligenceBus {
  final StreamController<IntelligenceEvent> _controller =
      StreamController<IntelligenceEvent>.broadcast();

  /// Stream of all intelligence events.
  Stream<IntelligenceEvent> get events => _controller.stream;

  /// Emits a new event to the bus.
  void emit(IntelligenceEvent event) {
    _controller.add(event);
  }

  /// Disposes the bus.
  void dispose() {
    _controller.close();
  }
}
