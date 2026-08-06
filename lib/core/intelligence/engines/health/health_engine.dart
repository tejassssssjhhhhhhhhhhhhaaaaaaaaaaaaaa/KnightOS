import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knight_os/core/intelligence/domain/health_models.dart';
import 'package:knight_os/core/intelligence/domain/cognitive_models.dart';
import 'package:knight_os/core/repositories/health_repository.dart';
import 'package:knight_os/core/intelligence/engines/health/health_context_engine.dart';
import 'package:knight_os/core/intelligence/providers/intelligence_providers.dart';
import 'package:knight_os/core/internal/utils/knight_logger.dart';
import 'package:knight_os/core/intelligence/services/knowledge_graph_service.dart';
import 'package:knight_os/core/intelligence/engines/verification_engine.dart';

final healthEngineProvider = Provider<HealthEngine>((ref) {
  return HealthEngine(
    repository: ref.watch(healthRepositoryProvider),
    contextEngine: ref.watch(healthContextEngineProvider),
    graphService: ref.watch(knowledgeGraphServiceProvider),
    verificationEngine: ref.watch(verificationEngineProvider),
  );
});

final healthContextEngineProvider = Provider<HealthContextEngine>((ref) {
   return HealthContextEngine(retrieval: ref.watch(memoryRetrievalEngineProvider));
});

class HealthEngine {
  final HealthRepository repository;
  final HealthContextEngine contextEngine;
  final KnowledgeGraphService graphService;
  final VerificationEngine verificationEngine;

  DateTime? _lastGraphUpdateTime;

  HealthEngine({
    required this.repository,
    required this.contextEngine,
    required this.graphService,
    required this.verificationEngine,
  });

  static const Map<String, double> sourceTrustWeights = {
    'Galaxy Watch': 0.95,
    'Samsung Health': 0.9,
    'Health Connect': 0.85,
    'Manual Input': 1.0,
    'AI Inference': 0.7,
  };

  Future<HealthScores> calculateCurrentScores() async {
    KnightLogger.info('[HEALTH_ENGINE] Starting score calculation cycle...', category: KnightLogCategory.intelligence);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final sleepResult = await _calculateSleepScore(today);
    final hydrationResult = await _calculateHydrationScore(today);
    final workoutResult = await _calculateWorkoutScore(today);
    final nutritionResult = await _calculateNutritionScore(today);
    final stressResult = await _calculateStressScore(today);
    final recoveryResult = await _calculateRecoveryScore(today, sleepResult);
    
    final readinessScoreValue = ((recoveryResult.score * 0.6) + (sleepResult.score * 0.4)).toInt();
    final readinessResult = HealthScoreResult(
      score: readinessScoreValue,
      trace: ReasoningTrace(
        intent: KnightIntent.analysis,
        memoriesUsed: [],
        rulesApplied: [],
        goalsConsidered: ['Physical Readiness'],
        thoughtChain: [
          'Weighted combination of physical recovery and sleep quality.',
          'Recovery weighted at 60%, Sleep at 40%.',
        ],
        confidence: (recoveryResult.trace.confidence * 0.6 + sleepResult.trace.confidence * 0.4),
        evidence: [
          Evidence(source: 'Derived', timestamp: now, trustWeight: 1.0, isObserved: false, freshness: 1.0),
        ],
      ),
    );
    
    final dailyScoreValue = (
      (sleepResult.score + hydrationResult.score + workoutResult.score + nutritionResult.score + stressResult.score + recoveryResult.score + readinessResult.score) / 7
    ).toInt();

    final dailyResult = HealthScoreResult(
      score: dailyScoreValue,
      trace: ReasoningTrace(
        intent: KnightIntent.analysis,
        memoriesUsed: [],
        rulesApplied: [],
        goalsConsidered: ['Overall Health'],
        thoughtChain: ['Average of all fundamental health metrics.'],
        confidence: 0.9,
      ),
    );

    // Task 3: Knowledge Graph Expansion (P0: Throttled to avoid main thread database pressure)
    if (_lastGraphUpdateTime == null || now.difference(_lastGraphUpdateTime!) > const Duration(hours: 1)) {
       await _updateKnowledgeGraph(
        sleep: sleepResult,
        recovery: recoveryResult,
        readiness: readinessResult,
        stress: stressResult,
        nutrition: nutritionResult,
        workout: workoutResult,
        hydration: hydrationResult,
      );
      _lastGraphUpdateTime = now;
    }

    // Task 1: Verification Mission triggering
    await _checkVerificationThresholds({
      'Sleep': sleepResult,
      'Hydration': hydrationResult,
      'Stress': stressResult,
    });

    KnightLogger.info('[HEALTH_ENGINE] Cycle complete. Daily Score: $dailyScoreValue', category: KnightLogCategory.intelligence);

    return HealthScores(
      dailyScore: dailyResult,
      recoveryScore: recoveryResult,
      sleepScore: sleepResult,
      stressScore: stressResult,
      hydrationScore: hydrationResult,
      nutritionScore: nutritionResult,
      workoutScore: workoutResult,
      readinessScore: readinessResult,
      timestamp: now,
    );
  }

  Future<void> _updateKnowledgeGraph({
    required HealthScoreResult sleep,
    required HealthScoreResult recovery,
    required HealthScoreResult readiness,
    required HealthScoreResult stress,
    required HealthScoreResult nutrition,
    required HealthScoreResult workout,
    required HealthScoreResult hydration,
  }) async {
    final sleepNode = await graphService.ensureNode(type: 'metric', label: 'Sleep');
    final recoveryNode = await graphService.ensureNode(type: 'metric', label: 'Recovery');
    final readinessNode = await graphService.ensureNode(type: 'metric', label: 'Readiness');
    final stressNode = await graphService.ensureNode(type: 'metric', label: 'Stress');
    final nutritionNode = await graphService.ensureNode(type: 'metric', label: 'Nutrition');
    final workoutNode = await graphService.ensureNode(type: 'metric', label: 'Workout');
    final hydrationNode = await graphService.ensureNode(type: 'metric', label: 'Hydration');

    await graphService.link(fromId: sleepNode, toId: recoveryNode, relationship: 'influences', weight: 0.8);
    await graphService.link(fromId: stressNode, toId: readinessNode, relationship: 'correlates', weight: -0.4);
    await graphService.link(fromId: recoveryNode, toId: readinessNode, relationship: 'composes', weight: 0.6);
    await graphService.link(fromId: workoutNode, toId: recoveryNode, relationship: 'depletes', weight: -0.3);
    await graphService.link(fromId: nutritionNode, toId: recoveryNode, relationship: 'supports', weight: 0.4);
    await graphService.link(fromId: hydrationNode, toId: stressNode, relationship: 'mitigates', weight: -0.2);
  }

  Future<void> _checkVerificationThresholds(Map<String, HealthScoreResult> results) async {
    for (final entry in results.entries) {
      final metric = entry.key;
      final result = entry.value;
      if (result.trace.confidence < 0.6) {
        KnightLogger.warn('[HEALTH_ENGINE] LOW CONFIDENCE (${result.trace.confidence}) detected for $metric');
        await verificationEngine.triggerSensorVerification(
          metric: metric,
          reason: result.trace.thoughtChain.lastOrNull ?? 'Uncertain data source',
          confidence: result.trace.confidence,
        );
      }
    }
  }

  Future<HealthScoreResult> _calculateSleepScore(DateTime day) async {
    final sleep = await repository.getRecentSleep(limit: 1);
    if (sleep.isEmpty) {
      return HealthScoreResult(
        score: 0,
        trace: ReasoningTrace(
          intent: KnightIntent.analysis,
          memoriesUsed: [],
          rulesApplied: [],
          goalsConsidered: ['Sleep Quality'],
          thoughtChain: ['No sleep records found for the target period.'],
          confidence: 0.0,
          missingEvidence: ['SleepSessionData'],
        ),
      );
    }
    
    final lastSleep = sleep.first;
    final durationHours = lastSleep.wakeTime.difference(lastSleep.bedTime).inHours;
    
    int score = (100 - (8 - durationHours).abs() * 10).clamp(0, 100);
    score = (score * (lastSleep.sleepQuality / 10.0)).toInt();
    
    final evidence = Evidence(
      source: 'Samsung Health',
      timestamp: lastSleep.wakeTime,
      trustWeight: sourceTrustWeights['Samsung Health']!,
      isObserved: true,
      freshness: 1.0,
    );

    return HealthScoreResult(
      score: score,
      trace: ReasoningTrace(
        intent: KnightIntent.analysis,
        memoriesUsed: [],
        rulesApplied: [],
        goalsConsidered: ['Sleep Quality'],
        thoughtChain: [
          'Calculated duration: ${durationHours}h.',
          'Applied quality multiplier: ${lastSleep.sleepQuality / 10.0}.',
        ],
        confidence: evidence.trustWeight,
        evidence: [evidence],
        recommendations: score < 70 ? ['Consider an earlier bedtime tonight.'] : [],
      ),
    );
  }

  Future<HealthScoreResult> _calculateHydrationScore(DateTime day) async {
    final intake = await repository.getWaterIntake(day);
    final score = (intake / 2000 * 100).toInt().clamp(0, 100);

    return HealthScoreResult(
      score: score,
      trace: ReasoningTrace(
        intent: KnightIntent.analysis,
        memoriesUsed: [],
        rulesApplied: [],
        goalsConsidered: ['Hydration'],
        thoughtChain: ['Measured intake: ${intake}ml against 2000ml goal.'],
        confidence: sourceTrustWeights['Manual Input']!,
        evidence: [
          Evidence(source: 'Manual Input', timestamp: day, trustWeight: 1.0, isObserved: true, freshness: 0.8),
        ],
        recommendations: score < 50 ? ['Drink 500ml of water now.'] : [],
      ),
    );
  }

  Future<HealthScoreResult> _calculateWorkoutScore(DateTime day) async {
    final workouts = await repository.getRecentWorkouts(limit: 7);
    if (workouts.isEmpty) return HealthScoreResult.empty();
    
    final todayWorkouts = workouts.where((w) => 
      w.startTime.year == day.year && w.startTime.month == day.month && w.startTime.day == day.day
    );
    
    int score = todayWorkouts.isNotEmpty ? 90 : (workouts.length / 7 * 100).toInt().clamp(0, 100);

    return HealthScoreResult(
      score: score,
      trace: ReasoningTrace(
        intent: KnightIntent.analysis,
        memoriesUsed: [],
        rulesApplied: [],
        goalsConsidered: ['Fitness Consistency'],
        thoughtChain: [
          todayWorkouts.isNotEmpty ? 'Workout detected today.' : 'Calculating consistency over 7 days.',
        ],
        confidence: 0.9,
      ),
    );
  }

  Future<HealthScoreResult> _calculateNutritionScore(DateTime day) async {
    final meals = await repository.getMealsForDay(day);
    int score = (meals.length / 3 * 100).toInt().clamp(0, 100);

    return HealthScoreResult(
      score: score,
      trace: ReasoningTrace(
        intent: KnightIntent.analysis,
        memoriesUsed: [],
        rulesApplied: [],
        goalsConsidered: ['Nutrition Balance'],
        thoughtChain: ['Logged ${meals.length} meals today.'],
        confidence: 1.0,
      ),
    );
  }

  Future<HealthScoreResult> _calculateStressScore(DateTime day) async {
    final stressMetrics = await repository.getMetricsForType('STRESS', day);
    if (stressMetrics.isEmpty) {
      return HealthScoreResult(
        score: 70,
        trace: ReasoningTrace(
          intent: KnightIntent.analysis,
          memoriesUsed: [],
          rulesApplied: [],
          goalsConsidered: ['Mental Well-being'],
          thoughtChain: ['Using default baseline due to missing sensor data.'],
          confidence: 0.5,
          assumptions: ['User is at baseline stress level.'],
        ),
      );
    }
    
    final avgStress = stressMetrics.map((m) => m.value).fold(0.0, (a, b) => a + b) / stressMetrics.length;
    int score = (100 - avgStress).toInt().clamp(0, 100);

    return HealthScoreResult(
      score: score,
      trace: ReasoningTrace(
        intent: KnightIntent.analysis,
        memoriesUsed: [],
        rulesApplied: [],
        goalsConsidered: ['Stress Management'],
        thoughtChain: ['Averaged ${stressMetrics.length} stress readings.'],
        confidence: sourceTrustWeights['Galaxy Watch']!,
        evidence: stressMetrics.map((m) => Evidence(
          source: 'Galaxy Watch',
          timestamp: m.startTime,
          trustWeight: 0.95,
          isObserved: true, freshness: 1.0,
        )).toList(),
      ),
    );
  }

  Future<HealthScoreResult> _calculateRecoveryScore(DateTime day, HealthScoreResult sleepResult) async {
    int score = (sleepResult.score * 0.8 + 10).toInt().clamp(0, 100);

    return HealthScoreResult(
      score: score,
      trace: ReasoningTrace(
        intent: KnightIntent.analysis,
        memoriesUsed: [],
        rulesApplied: [],
        goalsConsidered: ['System Recovery'],
        thoughtChain: ['Derived primarily from sleep quality metrics.'],
        confidence: sleepResult.trace.confidence * 0.9,
      ),
    );
  }
}
