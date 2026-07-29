import '../domain/knight_memory.dart';
import '../domain/memory_category.dart';
import '../domain/cognitive_models.dart';
import '../domain/reasoning_models.dart';
import '../knight_context_models.dart';
import '../../platform/engine/recommendation_models.dart';

/// Pure logic layer for KnightOS deductions.
/// Processes [KnightContext] and [KnightMemory] to find patterns and risks.
class ReasoningEngine {
  const ReasoningEngine();

  /// Deterministically reasons over the current situation.
  ReasoningResult reason({
    required KnightContext context,
    required List<KnightMemory> memories,
    Map<String, double> weights = const {},
  }) {
    final List<String> thoughts = [];
    final List<KnightInsight> insights = [];
    final List<KnightRecommendation> recommendations = [];
    final List<String> warnings = [];
    final List<String> opportunities = [];

    thoughts.add('Initiating weighted reasoning cycle at ${context.timestamp}');

    // 1. Daily Summary / Greeting Logic
    final summary = _generateSummary(context);
    thoughts.add('Situational summary generated: $summary');

    // 2. Rule: Health Risk Detection (Sleep)
    _applyHealthRules(context, warnings, recommendations, thoughts);

    // 3. Rule: Financial Awareness
    _applyFinancialRules(context, memories, thoughts);

    // 4. Rule: Mission Momentum
    _applyMissionRules(memories, insights, thoughts);

    // 5. Rule: World Awareness (Sprint 5.1)
    _applyWorldContextRules(context, insights, recommendations, warnings, thoughts);

    // 6. Environmental Opportunites
    if (context.weather.toLowerCase().contains('clear') || 
        context.weather.toLowerCase().contains('sunny')) {
      opportunities.add('Weather is optimal for outdoor activity or focused walking meditation.');
    }

    // 7. Semantic Connections (Sprint 1.5)
    if (context.relatedMemories.isNotEmpty) {
      thoughts.add('Augmented reasoning with ${context.relatedMemories.length} semantically related memories.');
    }

    // 8. Bridge Rules (Sprint 6)
    _applyBridgeRules(context, memories, warnings, recommendations, thoughts);

    // 9. Multimodal Tone (Sprint 7)
    _applyVoiceRules(context, thoughts);

    // 10. Apply Behavioral Learning Weights (Sprint 5.2)
    final filteredInsights = _applyWeightsToInsights(insights, weights, thoughts);
    final filteredRecommendations = _applyWeightsToRecommendations(recommendations, weights, thoughts);

    return ReasoningResult(
      summary: summary,
      insights: filteredInsights,
      recommendations: filteredRecommendations,
      warnings: warnings,
      opportunities: opportunities,
      trace: ReasoningTrace(
        intent: KnightIntent.analysis,
        memoriesUsed: memories.map((m) => m.memoryId).toList(),
        rulesApplied: ['deterministic-v4-standard', 'behavioral-learning-v1'],
        goalsConsidered: [],
        thoughtChain: thoughts,
        confidence: 0.8,
      ),
    );
  }

  /// Reasons specifically about why a workflow failed and suggests recovery.
  ReasoningResult reasonFailure({
    required String planId,
    required String taskId,
    required String error,
    required KnightContext context,
  }) {
    final List<String> thoughts = [
      'Analyzing failure in plan $planId at task $taskId',
      'Reported error: $error',
    ];

    final String recoverySummary;
    final List<KnightRecommendation> recommendations = [];

    if (error.toLowerCase().contains('timeout') || error.toLowerCase().contains('network')) {
      recoverySummary = 'Connectivity issue detected. Retrying with exponential backoff is advised.';
      recommendations.add(_createRecommendation(
        id: 'rec-recovery-retry',
        title: 'Retry Automation',
        description: 'The task timed out. I can retry this automatically when the network stabilizes.',
        category: KnightRecommendationCategory.system,
        priority: KnightRecommendationPriority.high,
      ));
    } else if (error.toLowerCase().contains('permission') || error.toLowerCase().contains('auth')) {
      recoverySummary = 'Security block encountered. Human intervention required for authorization.';
      recommendations.add(_createRecommendation(
        id: 'rec-recovery-auth',
        title: 'Authorize Knight',
        description: 'I need your permission to access this service to complete the plan.',
        category: KnightRecommendationCategory.security,
        priority: KnightRecommendationPriority.critical,
      ));
    } else {
      recoverySummary = 'Unexpected logical failure. Decomposing task to find alternative path.';
      thoughts.add('No standard recovery rule matched. Initiating generic decomposition.');
    }

    return ReasoningResult(
      summary: recoverySummary,
      insights: [],
      recommendations: recommendations,
      warnings: ['Workflow $planId stalled at $taskId'],
      opportunities: [],
      trace: ReasoningTrace(
        intent: KnightIntent.analysis,
        memoriesUsed: [],
        rulesApplied: ['workflow-failure-recovery'],
        goalsConsidered: [planId],
        thoughtChain: thoughts,
        confidence: 0.95,
      ),
    );
  }

  /// Suggests a detailed repair strategy for a failed workflow.
  ReasoningResult suggestRepairPlan({
    required String planId,
    required String taskId,
    required String error,
    required KnightContext context,
  }) {
    final List<String> thoughts = [
      'Task $taskId in plan $planId failed: $error',
      'No pre-defined fallbacks found. Initiating dynamic healing.',
    ];

    final String strategy;
    final List<KnightRecommendation> recommendations = [];

    if (error.toLowerCase().contains('api key') || error.toLowerCase().contains('secret')) {
      strategy = 'Credential Mismatch. Please update the integration settings for this plugin.';
      recommendations.add(_createRecommendation(
        id: 'rec-repair-creds',
        title: 'Update Credentials',
        description: 'The task failed due to invalid API keys. I can take you to the settings page.',
        category: KnightRecommendationCategory.security,
        priority: KnightRecommendationPriority.critical,
      ));
    } else {
      strategy = 'Heuristic Repair: I suggest decomposing this task into smaller steps to isolate the fault.';
      thoughts.add('Dynamic decomposition requested.');
    }

    return ReasoningResult(
      summary: strategy,
      insights: [],
      recommendations: recommendations,
      warnings: ['Workflow $planId requires manual repair at $taskId'],
      opportunities: [],
      trace: ReasoningTrace(
        intent: KnightIntent.analysis,
        memoriesUsed: [],
        rulesApplied: ['workflow-repair-heuristic'],
        goalsConsidered: [planId],
        thoughtChain: thoughts,
        confidence: 0.8,
      ),
    );
  }

  String _generateSummary(KnightContext context) {
    return 'It is ${context.greeting}. ${context.healthSummary}. System state is ${context.healthStatus}.';
  }

  void _applyHealthRules(
    KnightContext context,
    List<String> warnings,
    List<KnightRecommendation> recommendations,
    List<String> thoughts,
  ) {
    if (context.sleepStatus.toLowerCase().contains('debt') ||
        context.sleepStatus.toLowerCase().contains('low')) {
      warnings.add('High cognitive fatigue risk: ${context.sleepStatus}');
      thoughts.add('Rule triggered: Sleep deficit detected.');

      recommendations.add(
        _createRecommendation(
          id: 'rec-sleep-recovery',
          title: 'Prioritize Recovery',
          description:
              'Your sleep data indicates a deficit. Schedule a 20-min power nap before 3 PM.',
          category: KnightRecommendationCategory.sleep,
          priority: KnightRecommendationPriority.high,
        ),
      );
    }
  }

  void _applyFinancialRules(
    KnightContext context,
    List<KnightMemory> memories,
    List<String> thoughts,
  ) {
    final budgetRules =
        memories
            .where(
              (m) =>
                  m.category == BookCategory.philosophy &&
                  m.content['name']?.toString().toLowerCase().contains(
                        'budget',
                      ) ==
                      true,
            )
            .toList();

    if (budgetRules.isNotEmpty) {
      thoughts.add(
        'Analyzing financial constraints against ${budgetRules.length} rules.',
      );
    }
  }

  void _applyMissionRules(
    List<KnightMemory> memories,
    List<KnightInsight> insights,
    List<String> thoughts,
  ) {
    final activeMissions =
        memories
            .where(
              (m) =>
                  m.category == BookCategory.ambitions &&
                  m.content['missionDataType'] == 'mission',
            )
            .toList();

    if (activeMissions.isNotEmpty) {
      insights.add(
        KnightInsight(
          id: 'insight-mission-focus',
          title: 'Mission Alignment',
          description:
              'You have ${activeMissions.length} active missions. Current environment supports deep work on "${activeMissions.first.summary}".',
          confidence: 0.9,
          timestamp: DateTime.now(),
          explanation: 'Work-ready context identified in morning hours.',
        ),
      );
      thoughts.add('Rule triggered: Mission focus identified.');
    }
  }

  void _applyWorldContextRules(
    KnightContext context,
    List<KnightInsight> insights,
    List<KnightRecommendation> recommendations,
    List<String> warnings,
    List<String> thoughts,
  ) {
    final world = context.worldState;

    // 1. Mail Urgency (ASAP/Security/Action Required)
    for (final thread in world.emailThreads) {
      if (!thread.isUnread) continue;

      final isUrgent =
          thread.subject.toUpperCase().contains('ASAP') ||
          thread.subject.toUpperCase().contains('SECURITY') ||
          thread.subject.toUpperCase().contains('URGENT') ||
          thread.subject.toUpperCase().contains('ACTION REQUIRED');

      if (isUrgent) {
        thoughts.add('Rule triggered: Urgent mail detected - ${thread.subject}');
        warnings.add('Immediate attention required: ${thread.subject}');

          recommendations.add(
          _createRecommendation(
            id: 'rec-mail-urgent-${thread.id}',
            title: 'Review Urgent Mail',
            description:
                'Critical message from ${thread.sender}: "${thread.subject}". Handle immediately to avoid mission disruption.',
            category: KnightRecommendationCategory.work,
            priority: KnightRecommendationPriority.critical,
          ),
        );
      }
    }

    // 2. Meeting Proactivity (Prepare for next meeting)
    final now = DateTime.now();
    final nextMeetings =
        world.calendarEvents.where((e) {
          return e.startTime.isAfter(now) &&
              e.startTime.isBefore(now.add(const Duration(hours: 4)));
        }).toList();

    if (nextMeetings.isNotEmpty) {
      final next = nextMeetings.first;
      thoughts.add('Rule triggered: Upcoming meeting - ${next.title}');

      insights.add(
        KnightInsight(
          id: 'insight-cal-prepare-${next.id}',
          title: 'Meeting Preparation',
          description:
              'You have "${next.title}" at ${next.startTime.hour}:${next.startTime.minute.toString().padLeft(2, '0')}.',
          confidence: 1.0,
          timestamp: now,
          explanation: 'Contextual calendar awareness triggered.',
        ),
      );

      recommendations.add(
        _createRecommendation(
          id: 'rec-cal-prep-${next.id}',
          title: 'Review for ${next.title}',
          description:
              'Analyze recent memories related to "${next.title}" to optimize performance during this session.',
          category: KnightRecommendationCategory.work,
          priority: KnightRecommendationPriority.medium,
        ),
      );
    }

    // 3. Calendar Conflict Detection
    for (var i = 0; i < world.calendarEvents.length; i++) {
      for (var j = i + 1; j < world.calendarEvents.length; j++) {
        final a = world.calendarEvents[i];
        final b = world.calendarEvents[j];

        final isOverlap =
            (a.startTime.isBefore(b.endTime) && a.endTime.isAfter(b.startTime));

        if (isOverlap) {
          thoughts.add('Rule triggered: Calendar overlap detected between ${a.title} and ${b.title}');
          warnings.add('Schedule Conflict: ${a.title} overlaps with ${b.title}');
          
          recommendations.add(_createRecommendation(
            id: 'rec-cal-conflict-${a.id}-${b.id}',
            title: 'Resolve Schedule Conflict',
            description: 'You have two overlapping commitments. I can help reschedule one or prepare a conflict notice.',
            category: KnightRecommendationCategory.work,
            priority: KnightRecommendationPriority.high,
          ));
        }
      }
    }
  }

  void _applyBridgeRules(
    KnightContext context,
    List<KnightMemory> memories,
    List<String> warnings,
    List<KnightRecommendation> recommendations,
    List<String> thoughts,
  ) {
    // Finance -> Career Bridge
    final totalBalance = context.totalBalance;
    final highCostMissions = memories.where((m) => 
      m.category == BookCategory.ambitions && 
      (m.content['estimatedCost'] ?? 0) > totalBalance
    ).toList();

    if (highCostMissions.isNotEmpty) {
      final m = highCostMissions.first;
      thoughts.add('Rule triggered: Finance-Mission conflict - ${m.summary}');
      warnings.add('Financial Constraint: Mission "${m.summary}" exceeds currently liquid assets.');

      recommendations.add(_createRecommendation(
        id: 'rec-bridge-finance-${m.id}',
        title: 'Review Mission Budget',
        description: 'Consider breaking "${m.summary}" into lower-cost phases or adjusting the target date to allow for asset accumulation.',
        category: KnightRecommendationCategory.finance,
        priority: KnightRecommendationPriority.high,
      ));
    }
  }

  void _applyVoiceRules(KnightContext context, List<String> thoughts) {
    if (context.energyLevel == 'Low') {
      thoughts.add('Rule triggered: Low energy detected. Recommend gentle voice tone.');
    }
  }

  List<KnightInsight> _applyWeightsToInsights(
    List<KnightInsight> insights,
    Map<String, double> weights,
    List<String> thoughts,
  ) {
    final result = <KnightInsight>[];
    for (final insight in insights) {
      // Simplified mapping of insight ID prefixes to domains
      final domain = _mapInsightToDomain(insight.id);
      final weight = weights[domain] ?? 1.0;
      
      final weightedConfidence = insight.confidence * weight;
      if (weightedConfidence >= 0.4) {
        result.add(insight);
      } else {
        thoughts.add('Filtering low-weighted insight: ${insight.title} (Confidence: $weightedConfidence)');
      }
    }
    return result;
  }

  List<KnightRecommendation> _applyWeightsToRecommendations(
    List<KnightRecommendation> recommendations,
    Map<String, double> weights,
    List<String> thoughts,
  ) {
    final result = <KnightRecommendation>[];
    for (final rec in recommendations) {
      final domain = rec.category.name;
      final weight = weights[domain] ?? 1.0;
      
      final weightedConfidence = rec.confidence.value * weight;
      if (weightedConfidence >= 0.4 || rec.priority == KnightRecommendationPriority.critical) {
        result.add(rec);
      } else {
        thoughts.add('Filtering low-weighted recommendation: ${rec.title} (Confidence: $weightedConfidence)');
      }
    }
    return result;
  }

  String _mapInsightToDomain(String id) {
    if (id.contains('mission')) return 'goals';
    if (id.contains('cal')) return 'work';
    if (id.contains('mail')) return 'work';
    if (id.contains('sleep')) return 'sleep';
    return 'custom';
  }

  KnightRecommendation _createRecommendation({
    required String id,
    required String title,
    required String description,
    required KnightRecommendationCategory category,
    required KnightRecommendationPriority priority,
  }) {
    return KnightRecommendation(
      id: id,
      title: title,
      description: description,
      category: category,
      priority: priority,
      confidence: const KnightRecommendationConfidence(value: 0.9),
      reason: KnightRecommendationReason(summary: 'Rule-based trigger'),
      source: const KnightRecommendationSource(name: 'ReasoningEngine', version: '2.0.0'),
      action: const KnightRecommendationAction(label: 'View Detail'),
      timestamp: DateTime.now(),
    );
  }
}
