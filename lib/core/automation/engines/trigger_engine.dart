import 'dart:async';
import '../../intelligence/intelligence_bus.dart';
import '../../intelligence/domain/intelligence_events.dart';
import 'package:knight_os/core/internal/utils/knight_logger.dart';

/// Routes events to automation workflows based on pre-defined triggers.
class TriggerEngine {
  TriggerEngine({required this.bus});

  final IntelligenceBus bus;
  StreamSubscription? _busSub;

  final Map<Type, List<Future<void> Function(IntelligenceEvent)>> _triggers = {};

  void start() {
    _busSub = bus.events.listen(_onEvent);
    KnightLogger.info('[TRIGGER] Engine started.');
  }

  void on<T extends IntelligenceEvent>(Future<void> Function(T) callback) {
    _triggers[T] ??= [];
    _triggers[T]!.add((e) => callback(e as T));
  }

  void _onEvent(IntelligenceEvent event) {
    final callbacks = _triggers[event.runtimeType];
    if (callbacks != null) {
      for (final callback in callbacks) {
        callback(event);
      }
    }
  }

  void stop() {
    _busSub?.cancel();
  }
}
