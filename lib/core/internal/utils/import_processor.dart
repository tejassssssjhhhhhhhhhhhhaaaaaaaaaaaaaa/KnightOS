import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../../features/import/domain/import_models.dart';
import '../../../features/import/infrastructure/import_manager.dart';
import '../../../features/import/infrastructure/import_registry.dart';
import '../../../core/intelligence/engines/memory_engine.dart';

/// One-time utility to process specific files during development phases.
class ImportProcessor {
  const ImportProcessor._();

  static Future<void> processLocalTimeline(MemoryEngine engine) async {
    final file = File('C:/Users/tejas/Downloads/Timeline.json');
    if (!await file.exists()) {
      debugPrint('IMPORT ERROR: Timeline.json not found at expected path.');
      return;
    }

    final provider = ImportRegistry.providers.firstWhere(
      (p) => p.id == 'google_timeline',
    );

    debugPrint('STARTING MISSION: Ingesting Google Timeline...');
    final job = await ImportManager.executeMission(file, provider, engine);

    if (job.status == ImportStatus.completed) {
      debugPrint(
        'MISSION SUCCESS: ${job.processedCount} records integrated into Life Atlas.',
      );
    } else {
      debugPrint('MISSION FAILED: ${job.error}');
    }
  }
}
