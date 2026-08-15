import 'dart:async';
import '../intelligence_bus.dart';
import '../domain/intelligence_events.dart';
import '../domain/knight_memory.dart';
import '../domain/memory_category.dart';
import '../domain/memory_domain.dart';
import '../engines/memory_engine.dart';
import '../../internal/utils/knight_logger.dart';

/// Ingests text extracted via OCR into the Knowledge Vault.
class OcrKnowledgeService {
  OcrKnowledgeService({
    required this.bus,
    required this.memoryEngine,
  }) {
    _init();
  }

  final IntelligenceBus bus;
  final MemoryEngine memoryEngine;
  StreamSubscription? _busSub;

  void _init() {
    _busSub = bus.events.listen(_onEvent);
  }

  void _onEvent(IntelligenceEvent event) {
    if (event is UserInteractionEvent && event.payload['source'] == 'ocr') {
      _processOcr(event.payload['transcript'] as String? ?? '');
    }
  }

  Future<void> _processOcr(String text) async {
    if (text.isEmpty) return;

    KnightLogger.info('[OCR] Ingesting knowledge from document...');

    final memory = KnightMemory.create(
      memoryId: 'ocr-${DateTime.now().millisecondsSinceEpoch}',
      category: BookCategory.skills,
      domain: MemoryDomain.knowledge,
      source: MemorySource.manual,
      content: {'raw_text': text, 'type': 'ocr_ingestion'},
      summary: 'Document Import: ${text.split('\n').first.substring(0, 30)}...',
      confidence: 0.9,
      tags: ['ocr', 'knowledge_vault'],
    );

    await memoryEngine.save(memory);
    KnightLogger.info('[OCR] Knowledge saved to vault.');
  }

  void dispose() {
    _busSub?.cancel();
  }
}
