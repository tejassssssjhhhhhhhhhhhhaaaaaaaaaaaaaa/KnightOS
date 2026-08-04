import 'dart:async';
import 'domain/intelligence_events.dart';
import '../internal/utils/knight_logger.dart';
import '../platform/engine/engine_interfaces.dart';
import '../platform/engine/engine_types.dart';

/// Central event-dispatching and request-response hub for Knight Intelligence.
class IntelligenceBus implements KnightEventBus {
  final StreamController<KnightEngineEvent> _eventController =
      StreamController<KnightEngineEvent>.broadcast();
  
  final Map<Type, List<Function>> _requestHandlers = {};
  
  // Metrics
  int _eventCount = 0;
  int _requestCount = 0;
  int _errorCount = 0;

  /// Stream of all intelligence events.
  Stream<IntelligenceEvent> get events => _eventController.stream.where((e) => e is IntelligenceEvent).cast<IntelligenceEvent>();

  /// Stream of all engine events.
  Stream<KnightEngineEvent> get engineEvents => _eventController.stream;

  /// Emits a new event to the bus.
  @override
  Future<void> emit(KnightEngineEvent event) async {
    _eventCount++;
    KnightLogger.debug('[BUS] Emitting event: ${event.runtimeType}', category: KnightLogCategory.intelligence);
    _eventController.add(event);
  }

  /// Registers a listener for a specific event type.
  @override
  void listen<T extends KnightEngineEvent>(
    Future<void> Function(T event) listener,
  ) {
    _eventController.stream.where((e) => e is T).cast<T>().listen((e) => listener(e));
  }

  /// Removes a listener for a specific event type.
  @override
  void removeListener<T extends KnightEngineEvent>(
    Future<void> Function(T event) listener,
  ) {
    KnightLogger.warn('[BUS] removeListener called but not fully implemented', category: KnightLogCategory.intelligence);
  }

  /// Registers a handler for a specific request type.
  void registerHandler<REQ extends IntelligenceRequest, RES>(
    Future<RES> Function(REQ) handler,
  ) {
    _requestHandlers.putIfAbsent(REQ, () => []).add(handler);
    KnightLogger.info('[BUS] Registered handler for ${REQ.toString()}', category: KnightLogCategory.intelligence);
  }

  /// Sends a request and waits for the first available handler to respond.
  Future<RES> request<REQ extends IntelligenceRequest<RES>, RES>(REQ request) async {
    _requestCount++;
    final handlers = _requestHandlers[REQ];
    
    if (handlers == null || handlers.isEmpty) {
      _errorCount++;
      KnightLogger.error('[BUS] No handler registered for ${REQ.toString()}', category: KnightLogCategory.intelligence);
      throw StateError('No handler registered for ${REQ.toString()}');
    }

    KnightLogger.debug('[BUS] Processing request: ${REQ.toString()} (${request.requestId})', category: KnightLogCategory.intelligence);
    
    try {
      final handler = handlers.first as Future<RES> Function(REQ);
      final result = await handler(request);
      return result;
    } catch (e, stack) {
      _errorCount++;
      KnightLogger.error('[BUS] Error processing request ${request.requestId}: $e', stackTrace: stack, category: KnightLogCategory.intelligence);
      rethrow;
    }
  }

  /// Diagnostics
  Map<String, dynamic> getDiagnostics() {
    return {
      'eventCount': _eventCount,
      'requestCount': _requestCount,
      'errorCount': _errorCount,
      'registeredHandlers': _requestHandlers.keys.map((t) => t.toString()).toList(),
    };
  }

  /// Disposes the bus.
  void dispose() {
    _eventController.close();
    _requestHandlers.clear();
  }
}

/// Extension for easy request creation
extension RequestBusExtension on IntelligenceBus {
  Future<RES> send<RES>(IntelligenceRequest<RES> request) => this.request(request);
}
