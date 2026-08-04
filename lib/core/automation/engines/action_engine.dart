import 'dart:async';
import 'package:knight_os/core/internal/utils/knight_logger.dart';

/// Registry and executor for atomic automation actions.
class ActionEngine {
  ActionEngine();

  final Map<String, Future<dynamic> Function(Map<String, dynamic>)> _actions = {};

  void registerAction(String id, Future<dynamic> Function(Map<String, dynamic>) handler) {
    _actions[id] = handler;
  }

  Future<dynamic> execute(String actionId, [Map<String, dynamic> params = const {}]) async {
    final handler = _actions[actionId];
    if (handler == null) {
      throw Exception('Action not found: $actionId');
    }

    KnightLogger.info('[ACTION] Executing: $actionId');
    try {
      return await handler(params);
    } catch (e, s) {
      KnightLogger.error('[ACTION] Failed: $actionId', error: e, stackTrace: s);
      rethrow;
    }
  }
}
