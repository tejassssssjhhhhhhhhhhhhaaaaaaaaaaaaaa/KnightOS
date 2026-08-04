import 'package:collection/collection.dart';
import '../../domain/intelligence_module.dart';
import '../../domain/intelligence_events.dart';
import '../../domain/intelligence_models.dart';
import '../../domain/memory_category.dart';
import '../memory_retrieval_engine.dart';

class DailyBriefingModule extends IntelligenceModule {
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
    final firstFocus = focus.firstOrNull;
    if (firstFocus != null) {
      items.add('Today\'s Focus: ${firstFocus.summary}');
    }

    // 2. Health
    final health = await retrieval.getByCategory(BookCategory.health);
    final firstHealth = health.firstOrNull;
    if (firstHealth != null) {
      items.add('Wellness Note: ${firstHealth.summary}');
    }

    // 3. Finance
    final money = await retrieval.getByCategory(BookCategory.finance);
    final firstMoney = money.firstOrNull;
    if (firstMoney != null) {
      items.add('Budget Status: ₹${firstMoney.content['amount']} remaining');
    }

    return items;
  }
}
