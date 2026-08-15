import '../domain/knight_memory.dart';
import '../domain/mission_models.dart';
import '../domain/planning_models.dart';
import '../domain/reasoning_models.dart';
import '../knight_context_models.dart';
import '../../platform/engine/recommendation_models.dart';
import 'ai_provider.dart';
import 'optimization_engine.dart';

/// Advanced strategy layer for converting objectives into structured execution plans.
class PlanningEngine {
  const PlanningEngine({
    required this.aiProvider,
    this.optimizationEngine,
  });

  final KnightAiProvider aiProvider;
  final OptimizationEngine? optimizationEngine;

  /// Deterministically generates a plan based on reasoning and context.
  PlanningResult plan({
    required KnightContext context,
    required List<KnightMemory> memories,
    required ReasoningResult reasoning,
  }) {
    final List<KnightTask> suggestedTasks = [];
    final List<KnightPlan> activePlans = [];

    // 1. Convert Recommendations into Suggested Tasks
    for (final rec in reasoning.recommendations) {
      suggestedTasks.add(KnightTask(
        id: 'task-${rec.id}',
        title: rec.title,
        description: rec.description,
        priority: _mapPriority(rec.priority),
        isCompleted: false,
        category: rec.category.name,
      ));
    }

    // 2. Respond to Warnings with Mitigation Tasks
    for (final warning in reasoning.warnings) {
      if (warning.contains('sleep') || warning.contains('fatigue')) {
        suggestedTasks.add(const KnightTask(
          id: 'task-mitigation-sleep',
          title: 'Schedule Recovery Period',
          description: 'Mitigation task for detected cognitive fatigue.',
          priority: MissionPriority.critical,
          isCompleted: false,
          estimatedMinutes: 30,
        ));
      }
      if (warning.contains('dehydration') || warning.contains('water')) {
        suggestedTasks.add(const KnightTask(
          id: 'task-mitigation-water',
          title: 'Hydration Target',
          description: 'Drink 500ml water to maintain mission energy.',
          priority: MissionPriority.high,
          isCompleted: false,
          estimatedMinutes: 5,
        ));
      }
    }

    // 3. Assemble Daily Plan
    final dailyPlan = KnightPlan(
      id: 'daily-plan-${context.timestamp.toIso8601String().split('T').first}',
      title: 'Daily Mission Control',
      goalId: 'daily-objectives',
      status: MissionStatus.active,
      createdAt: context.timestamp,
      tasks: _prioritizeTasks(suggestedTasks, context),
    );

    return PlanningResult(
      dailyPlan: dailyPlan,
      activePlans: activePlans,
      suggestedTasks: suggestedTasks,
      timestamp: DateTime.now(),
      reasoningUsed: reasoning,
    );
  }

  /// AI-driven goal decomposition (Version 4).
  Future<KnightPlan> decomposeGoalWithAI({
    required String objective,
    required KnightContext context,
  }) async {
    // 1. Construct semantic prompt
    final prompt = 'Decompose this objective into 5 executable tasks with dependencies: $objective. User context: ${context.greeting}, Energy: ${context.energyLevel}';
    
    // 2. Query AI Provider
    await aiProvider.chat(context: [], prompt: prompt);
    
    // 3. Parse and normalize (Simulated for Sprint 1.1)
    final now = DateTime.now();
    final planId = 'plan-${now.millisecondsSinceEpoch}';
    
    return KnightPlan(
      id: planId,
      title: objective,
      goalId: 'goal-${objective.hashCode}',
      status: MissionStatus.active,
      createdAt: now,
      tasks: [
        KnightTask(
          id: '$planId-t1',
          title: 'Initial Research: $objective',
          priority: MissionPriority.high,
          isCompleted: false,
          estimatedMinutes: 60,
          category: 'learning',
        ),
        KnightTask(
          id: '$planId-t2',
          title: 'Infrastructure Setup',
          priority: MissionPriority.medium,
          isCompleted: false,
          estimatedMinutes: 120,
          category: 'work',
          dependencyIds: ['$planId-t1'],
        ),
      ],
      milestones: [
        KnightMilestone(
          id: '$planId-m1',
          title: 'Phase 1 Foundations',
          isReached: false,
          targetDate: now.add(const Duration(days: 7)),
        ),
      ],
    );
  }

  List<KnightTask> _prioritizeTasks(List<KnightTask> tasks, KnightContext context) {
    // Logic: If morning, prioritize high-energy tasks. If evening, prioritize review/reflection.
    final sorted = List<KnightTask>.from(tasks);
    sorted.sort((a, b) {
      // 0. Learned Weights (Sprint 1.7)
      final weightA = optimizationEngine?.getWeight(a.category ?? 'general') ?? 1.0;
      final weightB = optimizationEngine?.getWeight(b.category ?? 'general') ?? 1.0;

      // 1. Explicit Priority (Adjusted by Weight)
      final scoreA = a.priority.index * weightA;
      final scoreB = b.priority.index * weightB;
      
      final priorityComparison = scoreB.compareTo(scoreA);
      if (priorityComparison != 0) return priorityComparison;

      // 2. Contextual Alignment
      if (context.greeting == 'Morning') {
        if (a.category == 'work' && b.category != 'work') return -1;
        if (b.category == 'work' && a.category != 'work') return 1;
      }
      
      return 0;
    });
    return sorted;
  }

  MissionPriority _mapPriority(KnightRecommendationPriority p) {
    switch (p) {
      case KnightRecommendationPriority.critical:
        return MissionPriority.critical;
      case KnightRecommendationPriority.high:
        return MissionPriority.high;
      case KnightRecommendationPriority.medium:
        return MissionPriority.medium;
      case KnightRecommendationPriority.low:
        return MissionPriority.low;
    }
  }
}
