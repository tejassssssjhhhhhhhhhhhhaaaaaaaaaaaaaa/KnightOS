import 'package:collection/collection.dart';
import '../domain/activity_feed_models.dart';
import '../domain/knight_memory.dart';
import '../domain/memory_category.dart';
import '../domain/cognitive_models.dart';
import '../domain/reasoning_models.dart';
import '../knight_context_models.dart';
import 'local_llm_engine.dart';
import '../domain/workspace_models.dart';
import '../../platform/engine/recommendation_models.dart';

/// Pure logic layer for KnightOS deductions.
/// Processes [KnightContext] and [KnightMemory] to find patterns and risks.
class ReasoningEngine {
  const ReasoningEngine({this.llmEngine});

  final LocalLlmEngine? llmEngine;

  /// Deterministically reasons over the current situation.
  Future<ReasoningResult> reason({
    required KnightContext context,
    required List<KnightMemory> memories,
    Map<String, double> weights = const {},
    bool useAdvancedReasoning = false,
  }) async {
    final List<String> thoughts = [];
    final List<KnightInsight> insights = [];
    final List<KnightRecommendation> recommendations = [];
    final List<String> warnings = [];
    final List<String> opportunities = [];

    thoughts.add('Initiating weighted reasoning cycle at ${context.timestamp}');

    if (useAdvancedReasoning && llmEngine != null) {
      thoughts.add('Augmenting reasoning with local LLM inference...');
      final llmPrompt = _buildLlmPrompt(context, memories);
      final llmResult = await llmEngine!.reason(llmPrompt);
      thoughts.add('LLM Insight: ${llmResult.text}');
      // In a real system, we'd parse the LLM output into structured insights.
    }

    // 1. Daily Summary / Greeting Logic
    final summary = _generateSummary(context);
    thoughts.add('Situational summary generated: $summary');

    // 2. Rule: Health Risk Detection (Sleep)
    _applyHealthRules(context, warnings, recommendations, thoughts);

    // 3. Rule: Financial Awareness
    _applyFinancialRules(context, memories, thoughts);

    // 3.5. Structured Data Insights (V4)
    _applyStructuredDataInsights(context, insights, thoughts);

    // 3.6. Knowledge Graph Foundation (V5 Readiness)
    if (context.activityFeed.any((item) => item.type == ActivityType.import)) {
       thoughts.add('Graph Awareness: Relationships detected between structured imports and system nodes.');
    }

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

    // 9.5. Perception Rules (Milestone 3)
    _applyPerceptionRules(context, thoughts, recommendations);

    // 10. Workspace Memory Awareness (Milestone 7)
    _applyWorkspaceReasoning(memories, insights, recommendations, warnings, thoughts);

    // 11. Contextual Module Suggestions (Sprint V5.2 Phase 3)
    _applyModuleSuggestions(context, recommendations, thoughts);

    // 11.5. Mode Transition Suggestions (Sprint V5.3)
    _applyModeSuggestions(context, recommendations, thoughts);

    // 12. Apply Behavioral Learning Weights (Sprint 5.2)
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
  Future<ReasoningResult> reasonFailure({
    required String planId,
    required String taskId,
    required String error,
    required KnightContext context,
  }) async {
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
  Future<ReasoningResult> suggestRepairPlan({
    required String planId,
    required String taskId,
    required String error,
    required KnightContext context,
  }) async {
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

  String _buildLlmPrompt(KnightContext context, List<KnightMemory> memories) {
    return 'Context: ${context.healthStatus}, ${context.sleepStatus}. '
           'Memories: ${memories.map((m) => m.summary).join(", ")}. '
           'Analyze the situation and suggest a primary focus.';
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

  void _applyStructuredDataInsights(
    KnightContext context,
    List<KnightInsight> insights,
    List<String> thoughts,
  ) {
    // 1. Spending Insight
    if (context.totalBalance < 0) {
      insights.add(KnightInsight(
        id: 'insight-finance-negative',
        title: 'Negative Cash Flow',
        description: 'Your current total balance is negative (₹${context.totalBalance.toInt().abs()}). Prioritize essential expenses.',
        confidence: 1.0,
        timestamp: DateTime.now(),
      ));
      thoughts.add('Rule triggered: Negative balance detected.');
    } else if (context.totalBalance > 10000) {
       insights.add(KnightInsight(
        id: 'insight-finance-healthy',
        title: 'Healthy Savings',
        description: 'Total balance looks stable. Consider allocating extra funds to your active goals.',
        confidence: 0.8,
        timestamp: DateTime.now(),
      ));
      thoughts.add('Rule triggered: Healthy balance detected.');
    }

    // 2. Timeline Insight
    if (context.recentTimelineEvents.isNotEmpty) {
      final workVisits = context.recentTimelineEvents.where((e) => e.title.contains('Work') || e.type == 'visit').length;
      if (workVisits > 3) {
         insights.add(KnightInsight(
          id: 'insight-timeline-busy',
          title: 'High Activity Week',
          description: 'You\'ve had multiple work-site visits recently. Ensure you capture key takeaways in the Knowledge Vault.',
          confidence: 0.7,
          timestamp: DateTime.now(),
        ));
        thoughts.add('Rule triggered: High timeline activity detected.');
      }
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

    final firstMission = activeMissions.firstOrNull;
    if (firstMission != null) {
      insights.add(
        KnightInsight(
          id: 'insight-mission-focus',
          title: 'Mission Alignment',
          description:
              'You have ${activeMissions.length} active missions. Current environment supports deep work on "${firstMission.summary}".',
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

    final next = nextMeetings.firstOrNull;
    if (next != null) {
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

    final m = highCostMissions.firstOrNull;
    if (m != null) {
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

  void _applyPerceptionRules(KnightContext context, List<String> thoughts, List<KnightRecommendation> recommendations) {
    if (context.activeActivity == 'pocket_or_covered') {
       thoughts.add('Perception: Device is likely in a pocket or bag. Proactive suggestions will be muted until device is active.');
    } else if (context.activeActivity == 'moving_vibrant') {
       thoughts.add('Perception: User is highly active. Focusing on concise, time-sensitive updates.');
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

  void _applyWorkspaceReasoning(
    List<KnightMemory> memories,
    List<KnightInsight> insights,
    List<KnightRecommendation> recommendations,
    List<String> warnings,
    List<String> thoughts,
  ) {
    final workspaceMemories = memories.where((m) => m.tags.contains('workspace')).toList();
    if (workspaceMemories.isEmpty) return;

    thoughts.add('Analyzing ${workspaceMemories.length} workspace-origin memories.');

    for (final memory in workspaceMemories) {
      final dataType = memory.content['workspaceDataType'] as String?;
      
      // 1. Unread High-Importance Emails
      if (dataType == 'email') {
        final email = WorkspaceEmail.fromJson(memory.content);
        if (email.isUnread && (email.importance == 'high' || email.importance == 'critical')) {
          insights.add(KnightInsight(
            id: 'insight-workspace-urgent-email-${email.id}',
            title: 'Urgent Workspace Item',
            description: 'Actionable email from ${email.sender}: "${email.subject}"',
            confidence: memory.confidence,
            timestamp: DateTime.now(),
            explanation: 'Detected high-importance unread communication in Workspace context.',
          ));
        }
      }

      // 2. Calendar Event conflicts or upcoming preps
      if (dataType == 'calendar_event') {
        final event = WorkspaceCalendarEvent.fromJson(memory.content);
        final now = DateTime.now();
        if (event.startTime.isAfter(now) && event.startTime.isBefore(now.add(const Duration(hours: 12)))) {
          // Check for preparation docs in Drive
          final relatedDocs = workspaceMemories.where((m) => 
            m.content['workspaceDataType'] == 'drive_file' &&
            m.content['name'].toString().toLowerCase().contains(event.title.toLowerCase())
          ).toList();

          if (relatedDocs.isNotEmpty) {
             recommendations.add(_createRecommendation(
              id: 'rec-workspace-prep-${event.id}',
              title: 'Prepare for ${event.title}',
              description: 'I found ${relatedDocs.length} related documents in your Drive. Would you like to review them?',
              category: KnightRecommendationCategory.work,
              priority: KnightRecommendationPriority.high,
            ));
          }
        }
      }
    }
  }

  void _applyModeSuggestions(
    KnightContext context,
    List<KnightRecommendation> recommendations,
    List<String> thoughts,
  ) {
    final now = DateTime.now();
    
    // 1. Suggest Relaxation Mode in late hours if not active
    if (!context.isRelaxationMode && (now.hour >= 23 || now.hour < 5)) {
      thoughts.add('Rule triggered: Late hour detected. Recommending Relaxation Mode.');
      recommendations.add(_createRecommendation(
        id: 'rec-mode-relaxation',
        title: 'Activate Relaxation Mode',
        description: 'It is late. I suggest shifting into Relaxation Mode to prioritize rest and background maintenance.',
        category: KnightRecommendationCategory.system,
        priority: KnightRecommendationPriority.high,
      ));
    }

    // 2. Suggest Focus Mode during high-priority meeting blocks
    final hasUpcomingMeeting = context.recentTimelineEvents.any((e) => 
      e.type == 'meeting' && 
      e.startTime.isAfter(now) && 
      e.startTime.isBefore(now.add(const Duration(minutes: 15)))
    );

    if (hasUpcomingMeeting && !context.isFocusMode) {
      thoughts.add('Rule triggered: Meeting imminent. Recommending Focus Mode.');
      recommendations.add(_createRecommendation(
        id: 'rec-mode-focus',
        title: 'Enter Focus Mode',
        description: 'You have a meeting starting soon. Would you like to silence non-essential notifications?',
        category: KnightRecommendationCategory.work,
        priority: KnightRecommendationPriority.high,
      ));
    }
  }

  void _applyModuleSuggestions(
    KnightContext context,
    List<KnightRecommendation> recommendations,
    List<String> thoughts,
  ) {
    if (context.currentModule == 'finance' && context.totalBalance < 1000) {
      recommendations.add(_createRecommendation(
        id: 'rec-finance-check-budget',
        title: 'Review Budget',
        description: 'Your balance is lower than usual. Would you like to review your active budget?',
        category: KnightRecommendationCategory.finance,
        priority: KnightRecommendationPriority.high,
      ));
      thoughts.add('Contextual Rule: Low balance suggestion for Finance module.');
    }
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
