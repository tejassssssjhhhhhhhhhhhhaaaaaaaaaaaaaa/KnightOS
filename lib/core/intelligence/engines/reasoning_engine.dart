import '../domain/knight_memory.dart';
import '../domain/memory_category.dart';
import '../domain/cognitive_models.dart';
import '../domain/health_models.dart';
import '../domain/mission_models.dart';

/// The core logical processor for KnightOS.
class ReasoningEngine {
  const ReasoningEngine();

  /// Processes context to generate structured thoughts and identify risks.
  ReasoningTrace reason({
    required KnightIntent intent,
    required List<KnightMemory> context,
  }) {
    final List<String> thoughtChain = [];
    final List<String> potentialRisks = [];

    thoughtChain.add("Analyzing intent: ${intent.name}");

    // 1. Identify active goals and rules
    final goals = context
        .where((m) => m.category == BookCategory.ambitions)
        .toList();
    final rules = context
        .where((m) => m.category == BookCategory.philosophy)
        .toList();

    thoughtChain.add(
      "Loaded ${goals.length} goals and ${rules.length} life rules.",
    );

    // 2. Health Risk Detection (Phase 9)
    final healthMemories = context
        .where((m) => m.category == BookCategory.health)
        .toList();
    if (healthMemories.isNotEmpty) {
      final sleepDebt = _calculateSleepDebt(healthMemories);
      if (sleepDebt > 2.0) {
        potentialRisks.add(
          "Significant sleep debt detected (${sleepDebt.toStringAsFixed(1)}h). High risk of cognitive fatigue.",
        );
        thoughtChain.add("Sleep debt analyzed: $sleepDebt hours.");
      }
    }

    // 3. Mission Progress Assessment (Phase 14)
    final missionMemories = context.where((m) => m.isMissionType).toList();
    if (missionMemories.isNotEmpty) {
      thoughtChain.add(
        "Evaluating progress for ${missionMemories.length} mission entities.",
      );
    }

    // 4. Conflict Detection (Knight Challenge Mode Foundation)
    for (final rule in rules) {
      // Simplistic placeholder for conflict logic:
      // If intent is Decision, check if any recent memories violate rules.
      if (intent == KnightIntent.decision) {
        final conflict = _detectRuleConflict(rule, context);
        if (conflict != null) {
          potentialRisks.add(conflict);
          thoughtChain.add("Conflict detected with rule: ${rule.summary}");
        }
      }
    }

    // 3. Confidence Evaluation
    final averageConfidence = context.isEmpty
        ? 0.5
        : context.map((m) => m.confidence).reduce((a, b) => a + b) /
              context.length;

    return ReasoningTrace(
      intent: intent,
      memoriesUsed: context.map((m) => m.id).toList(),
      rulesApplied: rules.map((r) => r.id).toList(),
      goalsConsidered: goals.map((g) => g.id).toList(),
      thoughtChain: thoughtChain,
      confidence: averageConfidence,
      potentialRisks: potentialRisks,
    );
  }

  double _calculateSleepDebt(List<KnightMemory> healthMemories) {
    final sleepRecords = healthMemories
        .where((m) => m.healthDataType == HealthDataType.sleep)
        .map((m) => m.toSleepRecord()!)
        .toList();
    if (sleepRecords.isEmpty) return 0.0;

    final avgDuration =
        sleepRecords.fold(0, (sum, r) => sum + r.durationMinutes) /
        sleepRecords.length;
    return (8.0 - (avgDuration / 60.0)).clamp(0.0, 10.0);
  }

  String? _detectRuleConflict(KnightMemory rule, List<KnightMemory> context) {
    // Example: Rule 'max-monthly-budget'
    if (rule.content['name']?.toString().toLowerCase().contains('budget') ==
        true) {
      final maxBudget = double.tryParse(
        rule.content['constraints']?['max']?.toString() ?? '',
      );
      if (maxBudget != null) {
        // Check if current expenses in context exceed or approach this.
        final moneyMemories = context
            .where((m) => m.category == BookCategory.finance)
            .toList();
        // (Simplified logic for foundation)
        if (moneyMemories.any((m) => (m.content['amount'] ?? 0) > maxBudget)) {
          return "Request may violate your '${rule.content['name']}' rule of \$$maxBudget.";
        }
      }
    }
    return null;
  }
}
