import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../providers/database_provider.dart';

enum RuntimeEventSeverity { info, warning, error, critical }

class RuntimeRecorderService {
  RuntimeRecorderService({required this.db});
  final KnightDatabase db;

  Future<void> record({
    required String category,
    required String message,
    RuntimeEventSeverity severity = RuntimeEventSeverity.info,
    Map<String, dynamic>? metadata,
    String? sessionId,
  }) async {
    try {
      await db.runtimeRecorderDao.logEvent(RuntimeEventsTableCompanion.insert(
        id: const Uuid().v4(),
        category: category,
        message: message,
        severity: Value(severity.name),
        metadata: Value(metadata != null ? jsonEncode(metadata) : null),
        sessionId: Value(sessionId),
        createdAt: Value(DateTime.now()),
      ));
    } catch (e) {
      // Don't use KnightLogger here to avoid infinite recursion if it calls capture
      debugPrint('CRITICAL: RuntimeRecorder failed: $e');
    }
  }

  Future<List<RuntimeEvent>> getRecent(int limit) => db.runtimeRecorderDao.getRecentEvents(limit: limit);
}

final runtimeRecorderServiceProvider = Provider<RuntimeRecorderService>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  return RuntimeRecorderService(db: db);
});
