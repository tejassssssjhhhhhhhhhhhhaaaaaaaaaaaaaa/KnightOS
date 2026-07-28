import '../../domain/intelligence_module.dart';
import '../../domain/intelligence_events.dart';
import '../../domain/intelligence_models.dart';
import '../../domain/memory_category.dart';
import '../memory_retrieval_engine.dart';

class DailyBriefingModule implements IntelligenceModule {
  DailyBriefingModule({required this.retrieval});

  final MemoryRetrievalEngine retrieval;

  @override
  String get id => 'daily_briefing';

  @override
  List<BookCategory> get inputCategories => [
    BookCategory.career,
    BookCategory.health,
    BookCategory.finance,
    BookCategory.ambitions,
  ];

  @override
  double get priority => 0.9;

  @override
  Future<void> onEvent(IntelligenceEvent event) async {
    // Briefing is usually generated on demand, but we could pre-calculate on major imports
  }

  @override
  Future<List<IntelligenceResult>> getInsights() async => [];

  @override
  Future<List<IntelligenceResult>> getRecommendations() async => [];

  @override
  Future<List<String>> getBriefingItems() async {
    final List<String> items = [];

    // 1. Priorities
    final focus = await retrieval.getByCategory(BookCategory.career);
    if (focus.isNotEmpty) {
      items.add('Today\'s Focus: ${focus.first.summary}');
    }

    // 2. Health
    final health = await retrieval.getByCategory(BookCategory.health);
    if (health.isNotEmpty) {
      items.add('Wellness Note: ${health.first.summary}');
    }

    // 3. Finance
    final money = await retrieval.getByCategory(BookCategory.finance);
    if (money.isNotEmpty) {
      items.add('Budget Status: ₹${money.first.content['amount']} remaining');
    }

    return items;
  }
}
