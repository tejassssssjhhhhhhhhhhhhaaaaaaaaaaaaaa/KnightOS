import 'dart:async';
import 'dart:isolate';
import '../../internal/utils/knight_logger.dart';

/// Request for the Edge-AI Isolate.
class EdgeAiRequest {
  const EdgeAiRequest({
    required this.id,
    required this.task,
    this.payload,
  });

  final String id;
  final String task;
  final dynamic payload;
}

/// Result from the Edge-AI Isolate.
class EdgeAiResponse {
  const EdgeAiResponse({
    required this.id,
    this.data,
    this.error,
  });

  final String id;
  final dynamic data;
  final String? error;
}

/// Manages a pool of background isolates for heavy intelligence processing.
class EdgeAiOrchestrator {
  EdgeAiOrchestrator({this.workerCount = 1});

  final int workerCount;
  final Map<String, Completer<EdgeAiResponse>> _pendingRequests = {};
  
  SendPort? _sendPort;
  Isolate? _isolate;
  final ReceivePort _receivePort = ReceivePort();

  Future<void> initialize() async {
    KnightLogger.info('[EDGE-AI] Initializing Isolate Orchestrator...', category: KnightLogCategory.intelligence);
    
    _isolate = await Isolate.spawn(_isolateEntry, _receivePort.sendPort);
    
    final completer = Completer<void>();
    _receivePort.listen((message) {
      if (message is SendPort) {
        _sendPort = message;
        completer.complete();
      } else if (message is EdgeAiResponse) {
        final pending = _pendingRequests.remove(message.id);
        if (pending != null) {
          if (message.error != null) {
            pending.completeError(message.error!);
          } else {
            pending.complete(message);
          }
        }
      }
    });

    return completer.future;
  }

  /// Offloads a task to the background isolate.
  Future<EdgeAiResponse> compute(String task, dynamic payload) async {
    if (_sendPort == null) {
      throw StateError('EdgeAiOrchestrator not initialized');
    }

    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final completer = Completer<EdgeAiResponse>();
    _pendingRequests[id] = completer;

    _sendPort!.send(EdgeAiRequest(id: id, task: task, payload: payload));

    return completer.future;
  }

  static void _isolateEntry(SendPort mainSendPort) {
    final receivePort = ReceivePort();
    mainSendPort.send(receivePort.sendPort);

    receivePort.listen((message) {
      if (message is EdgeAiRequest) {
        // Handle heavy task execution here
        try {
          final result = _handleTask(message.task, message.payload);
          mainSendPort.send(EdgeAiResponse(id: message.id, data: result));
        } catch (e) {
          mainSendPort.send(EdgeAiResponse(id: message.id, error: e.toString()));
        }
      }
    });
  }

  static dynamic _handleTask(String task, dynamic payload) {
    // This is where heavy reasoning, synthesis, or LLM execution would happen.
    // For now, we simulate a heavy computation.
    if (task == 'reasoning') {
      // Simulate heavy work
      return 'Processed reasoning for $payload';
    }
    if (task == 'perception_analysis') {
       // Simulate heavy pattern matching on sensor vectors
       return 'active_movement_pattern';
    }
    return null;
  }

  void dispose() {
    _isolate?.kill();
    _receivePort.close();
    _pendingRequests.clear();
  }
}
