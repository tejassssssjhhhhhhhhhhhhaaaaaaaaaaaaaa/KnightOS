import 'dart:async';
import '../domain/events/integration_events.dart';
import '../internal/utils/knight_logger.dart';

/// Decoupled communication hub for KnightOS platform events.
class EventBus {
  EventBus._();
  static final EventBus instance = EventBus._();

  final StreamController<KnightEvent> _controller = StreamController<KnightEvent>.broadcast();

  /// Stream of all events.
  Stream<KnightEvent> get onEvent => _controller.stream;

  /// Stream of specific event types.
  Stream<T> on<T extends KnightEvent>() {
    return _controller.stream.where((event) => event is T).cast<T>();
  }

  /// Publishes a new event to the bus.
  void publish(KnightEvent event) {
    KnightLogger.info('[EVENT] Published: ${event.runtimeType}');
    _controller.add(event);
  }

  void dispose() {
    _controller.close();
  }
}
