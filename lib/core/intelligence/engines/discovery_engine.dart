import '../domain/knight_memory.dart';
import '../domain/memory_category.dart';
import '../domain/memory_metadata.dart';
import 'memory_engine.dart';
import 'verification_engine.dart';
import '../../../features/discovery/domain/discovery_models.dart';
import '../../../features/discovery/infrastructure/question_bank_loader.dart';

/// Orchestrates the conversational learning process of KnightOS.
class DiscoveryEngine {
  const DiscoveryEngine({
    required this.memoryEngine,
    required this.loader,
    required this.verificationEngine,
  });

  final MemoryEngine memoryEngine;
  final QuestionBankLoader loader;
  final VerificationEngine verificationEngine;

  Future<dynamic> getNextMission() async {
    // 1. Check for high-importance Verifications
    final pendingVerifications = await verificationEngine
        .getPendingVerifications();

    // Prioritize critical verifications (priority < 20)
    final criticalVerifications = pendingVerifications
        .where((v) => v.priority < 20)
        .toList();
    if (criticalVerifications.isNotEmpty) {
      return criticalVerifications.first; // Return VerificationMission
    }

    // 2. Standard Discovery Question
    final question = await _getNextDiscoveryQuestion();
    if (question != null) {
      return question; // Return DiscoveryQuestion
    }

    // 3. Fallback to low-priority verifications
    if (pendingVerifications.isNotEmpty) {
      return pendingVerifications.first;
    }

    return null;
  }

  Future<DiscoveryQuestion?> _getNextDiscoveryQuestion() async {
    final allQuestions = await loader.loadFromAssets();

    // Get all known info to avoid redundant questions
    final existingMemories = await memoryEngine.search('');

    // SSOT SUPPRESSION: Filter questions whose answers exist in Observed memories
    final knownQuestionIds = existingMemories
        .where(
          (m) => m.questionId != null && m.state != KnowledgeState.deprecated,
        )
        .map((m) => m.questionId!)
        .toSet();

    // Also suppress if the memory domain has high density from imports
    // (Simulated logic for Phase 8)

    final potentialQuestions = allQuestions.where((q) {
      if (knownQuestionIds.contains(q.id)) return false;
      for (final depId in q.dependencies) {
        if (!knownQuestionIds.contains(depId)) return false;
      }
      return true;
    }).toList();

    if (potentialQuestions.isEmpty) return null;

    potentialQuestions.sort(
      (a, b) => a.priority.index.compareTo(b.priority.index),
    );
    return potentialQuestions.first;
  }

  /// Records an answer as a structured memory.
  Future<void> answerQuestion(
    DiscoveryQuestion question,
    dynamic answer,
  ) async {
    final memory = KnightMemory.create(
      memoryId: 'discovery-${question.id}',
      category: question.category,
      domain: question.domain,
      content: {'question': question.text, 'answer': answer},
      summary: '${question.text}: $answer',
      source: MemorySource.manual,
      verified: true,
      knowledgeState: KnowledgeState.userConfirmed,
      questionId: question.id,
      importance: question.priority == QuestionPriority.critical ? 1.0 : 0.7,
    );

    await memoryEngine.save(memory);
  }

  /// Calculates the completion percentage for a specific book.
  Future<double> getCompletionRate(BookCategory category) async {
    final allQuestions = await loader.loadFromAssets();
    final bookQuestions = allQuestions
        .where((q) => q.category == category)
        .toList();
    if (bookQuestions.isEmpty) return 1.0;

    final existingMemories = await memoryEngine.getByCategory(category);
    final answeredIds = existingMemories
        .where(
          (m) =>
              m.questionId != null && m.state == KnowledgeState.userConfirmed,
        )
        .map((m) => m.questionId!)
        .toSet();

    int answeredCount = 0;
    for (final q in bookQuestions) {
      if (answeredIds.contains(q.id)) answeredCount++;
    }

    return answeredCount / bookQuestions.length;
  }
}
