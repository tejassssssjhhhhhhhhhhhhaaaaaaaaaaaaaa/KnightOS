import '../../domain/intelligence_module.dart';
import '../../domain/intelligence_events.dart';
import '../../domain/intelligence_models.dart';
import '../../domain/memory_category.dart';
import '../memory_retrieval_engine.dart';
import '../synthesis_engine.dart';

class SynthesisModule implements IntelligenceModule {
  SynthesisModule({
    required this.retrieval,
    required this.synthesisEngine,
  });

  final MemoryRetrievalEngine retrieval;
  final SynthesisEngine synthesisEngine;

  @override
  String get id => 'knowledge_synthesis';

  @override
  List<BookCategory> get inputCategories => [
    BookCategory.history,
    BookCategory.finance,
    BookCategory.health,
  ];

  @override
  double get priority => 0.75;

  @override
  Future<void> onEvent(IntelligenceEvent event) async {}

  @override
  Future<List<IntelligenceResult>> getInsights() async {
    return synthesisEngine.performCrossChapterSynthesis();
  }

  @override
  Future<List<IntelligenceResult>> getRecommendations() async => [];

  @override
  Future<List<String>> getBriefingItems() async => [];
}
