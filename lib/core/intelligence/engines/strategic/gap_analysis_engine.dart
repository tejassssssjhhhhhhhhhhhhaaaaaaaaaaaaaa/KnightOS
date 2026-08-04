import '../../domain/knight_memory.dart';
import '../../domain/memory_category.dart';
import '../../domain/cognitive_models.dart';
import '../../../domain/entities/strategic_models.dart';
import '../../../domain/entities/evidence.dart' as entity_evidence;
import '../memory_engine.dart';

/// Analyzes the gap between current reality and strategic North Stars.
class GapAnalysisEngine {
  const GapAnalysisEngine({required this.memoryEngine});

  final MemoryEngine memoryEngine;

  /// Performs a comprehensive gap analysis for a specific North Star.
  Future<GapReport> analyze(NorthStar northStar) async {
    // 1. Fetch current domain-related memories (Skills, Achievements, Timeline)
    final domainMemories = await memoryEngine.getByCategory(_mapDomainToCategory(northStar.domain));
    final skills = await memoryEngine.getByCategory(BookCategory.skills);
    
    // 2. Identify missing elements based on North Star target state
    // In a production LLM-backed system, this would use semantic comparison.
    // For MVP, we use heuristic matching of target keywords against evidence.
    final targetKeywords = northStar.targetState?.toLowerCase().split(' ') ?? [];
    
    final missingSkills = <String>[];
    if (targetKeywords.contains('principal') || targetKeywords.contains('architect')) {
      if (!_hasSkill(skills, 'System Design')) missingSkills.add('System Design');
      if (!_hasSkill(skills, 'Leadership')) missingSkills.add('Technical Leadership');
    }

    // 3. Calculate Confidence based on evidence density
    final evidenceCount = domainMemories.length;
    final confidence = (evidenceCount / 10).clamp(0.5, 0.95);

    return GapReport(
      northStarId: northStar.id,
      missingSkills: missingSkills,
      missingEvidence: missingSkills.map((s) => 'Verified projects demonstrating $s').toList(),
      currentPosition: 'Currently ${northStar.progress * 100}% towards ${northStar.title}',
      highestImpactAction: missingSkills.isNotEmpty 
          ? 'Complete a mission to demonstrate ${missingSkills.first}' 
          : 'Refine your North Star target state for deeper analysis.',
      confidence: confidence,
    );
  }

  bool _hasSkill(List<KnightMemory> skills, String name) {
    return skills.any((s) => (s.content['name'] ?? '').toString().toLowerCase() == name.toLowerCase());
  }

  BookCategory _mapDomainToCategory(String domain) {
    switch (domain.toLowerCase()) {
      case 'career': return BookCategory.career;
      case 'health': return BookCategory.health;
      case 'finance': return BookCategory.finance;
      default: return BookCategory.unknown;
    }
  }
}

/// A structured report of the delta between current state and a strategic target.
class GapReport {
  const GapReport({
    required this.northStarId,
    required this.missingSkills,
    required this.missingEvidence,
    required this.currentPosition,
    required this.highestImpactAction,
    required this.confidence,
  });

  final String northStarId;
  final List<String> missingSkills;
  final List<String> missingEvidence;
  final String currentPosition;
  final String highestImpactAction;
  final double confidence;
}
