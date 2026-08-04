import 'dart:async';
import '../../domain/intelligence_module.dart';
import '../../domain/intelligence_events.dart';
import '../../domain/intelligence_models.dart';
import '../../domain/memory_category.dart';
import '../../domain/cognitive_models.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import '../../services/knowledge_graph_service.dart';

/// Analyzes financial transactions and provides budgeting insights.
class FinanceModule extends IntelligenceModule {
  FinanceModule({required this.db, required this.graphService});

  final KnightDatabase db;
  final KnowledgeGraphService graphService;

  @override
  String get id => 'finance_intelligence';

  @override
  List<BookCategory> get inputCategories => [BookCategory.philosophy]; // Transactions often categorized here or custom

  @override
  double get priority => 0.8;

  @override
  Future<void> onEvent(IntelligenceEvent event) async {
    // React to new transactions
    if (event is DataChangedEvent) {
       // Logic to link transactions to mission goals in the Knowledge Graph
    }
  }

  @override
  Future<List<IntelligenceResult>> getInsights() async {
    final balance = await db.financialDao.getTotalBalance();
    final List<IntelligenceResult> insights = [];

    if (balance < 1000.0) {
      insights.add(IntelligenceResult(
        id: 'insight-finance-low-balance',
        data: 'Total balance is low (₹${balance.toStringAsFixed(2)}). Consider delaying non-essential mission tasks.',
        trace: ReasoningTrace(
          intent: KnightIntent.analysis,
          memoriesUsed: [],
          rulesApplied: ['Liquidity Risk Rule v1'],
          goalsConsidered: ['Financial Security'],
          thoughtChain: ['Checked total account balances.', 'Identified liquidity threshold breach.'],
          confidence: 1.0,
        ),
        generatedAt: DateTime.now(),
        version: 1,
        evidenceHash: 'finance-low-hash',
      ));
    }

    return insights;
  }

  @override
  Future<List<IntelligenceResult>> getRecommendations() async {
    return [];
  }

  @override
  Future<List<String>> getBriefingItems() async {
    final balance = await db.financialDao.getTotalBalance();
    return ['Finance: Total balance is ₹${balance.toStringAsFixed(2)}.'];
  }
}
