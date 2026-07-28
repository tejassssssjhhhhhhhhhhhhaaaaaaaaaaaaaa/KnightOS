import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/memory_category.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';
import 'package:knight_os/core/intelligence/engines/memory_engine.dart';
import 'package:knight_os/core/intelligence/domain/repositories/drift_memory_repository.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import 'package:knight_os/core/intelligence/services/json_validation_service.dart';

void main() async {
  print('Starting KnightOS Import Mission...');

  // Initialize Database & Engine
  final db = KnightDatabase.forTesting(NativeDatabase.memory()); // Use a real file in production
  final repository = DriftMemoryRepository(memoryDao: db.memoryDao);
  final validationService = JsonValidationService(schemaDirectory: 'knight_knowledge_base/schemas/master_memory');
  final memoryEngine = MemoryEngine(repository: repository, validationService: validationService);

  final importReport = {
    'files_processed': 0,
    'records_imported': 0,
    'duplicates': 0,
    'errors': 0,
  };

  // 1. Import Timeline.json
  await _importTimeline(File('C:\\Users\\tejas\\Downloads\\Timeline.json'), memoryEngine, importReport);

  // 2. Import CSV Logs
  await _importCsv(File('C:\\Users\\tejas\\OneDrive\\Desktop\\Knight OS\\data\\daily_log.csv'), memoryEngine, importReport);
  await _importCsv(File('C:\\Users\\tejas\\OneDrive\\Desktop\\Knight OS\\data\\sleep.csv'), memoryEngine, importReport);

  print('--- FINAL IMPORT REPORT ---');
  print('Files Processed: ${importReport['files_processed']}');
  print('Records Imported: ${importReport['records_imported']}');
  print('Duplicates: ${importReport['duplicates']}');
  print('Errors: ${importReport['errors']}');
  
  await db.close();
}

Future<void> _importTimeline(File file, MemoryEngine engine, Map<String, int> report) async {
  if (!await file.exists()) return;
  print('Importing Timeline: ${file.path}');
  
  try {
    final content = await file.readAsString();
    final data = jsonDecode(content);
    final segments = data['semanticSegments'] as List<dynamic>? ?? [];
    
    int count = 0;
    for (final segment in segments) {
      final startTime = DateTime.tryParse(segment['startTime'] ?? '');
      if (startTime == null) continue;

      String summary = 'Timeline Event';
      MemoryDomain domain = MemoryDomain.travel;
      
      if (segment['activity'] != null) {
        final type = segment['activity']['topCandidate']?['type'] ?? 'MOVE';
        summary = 'Activity: $type';
      } else if (segment['visit'] != null) {
        final placeId = segment['visit']['topCandidate']?['placeId'] ?? 'Place';
        summary = 'Visit: $placeId';
        domain = MemoryDomain.identity;
      }

      final memory = KnightMemory.create(
        memoryId: 'timeline-${startTime.millisecondsSinceEpoch}-$count',
        category: BookCategory.history,
        domain: domain,
        source: MemorySource.imported,
        content: segment as Map<String, dynamic>,
        summary: summary,
        effectiveAt: startTime,
        provenance: 'Timeline.json',
        confidence: 0.95,
      );

      await engine.save(memory);
      count++;
    }
    
    report['files_processed'] = (report['files_processed'] ?? 0) + 1;
    report['records_imported'] = (report['records_imported'] ?? 0) + count;
    print('Imported $count timeline records.');
  } catch (e) {
    print('Error importing Timeline: $e');
    report['errors'] = (report['errors'] ?? 0) + 1;
  }
}

Future<void> _importCsv(File file, MemoryEngine engine, Map<String, int> report) async {
  if (!await file.exists()) return;
  print('Importing CSV: ${file.path}');
  
  try {
    final lines = await file.readAsLines();
    if (lines.length < 2) return;
    
    final headers = lines.first.split(',');
    int count = 0;
    
    for (int i = 1; i < lines.length; i++) {
      final values = lines[i].split(',');
      if (values.length != headers.length) continue;
      
      final content = <String, dynamic>{};
      for (int j = 0; j < headers.length; j++) {
        content[headers[j]] = values[j];
      }

      final memory = KnightMemory.create(
        memoryId: 'csv-${file.path.split('\\').last}-$i',
        category: file.path.contains('sleep') ? BookCategory.health : BookCategory.career,
        domain: file.path.contains('sleep') ? MemoryDomain.health : MemoryDomain.projects,
        source: MemorySource.imported,
        content: content,
        summary: 'Log Entry from ${file.path.split('\\').last}',
        provenance: file.path,
        confidence: 1.0,
      );

      await engine.save(memory);
      count++;
    }
    
    report['files_processed'] = (report['files_processed'] ?? 0) + 1;
    report['records_imported'] = (report['records_imported'] ?? 0) + count;
    print('Imported $count CSV records.');
  } catch (e) {
    print('Error importing CSV: $e');
    report['errors'] = (report['errors'] ?? 0) + 1;
  }
}
