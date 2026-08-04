import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../../core/intelligence/domain/memory_category.dart';
import '../../../../core/intelligence/domain/knight_memory.dart';
import '../../domain/career_models.dart';

class CareerDnaState {
  const CareerDnaState({
    this.skills = const [],
    this.isLoading = false,
    this.error,
  });

  final List<SkillIntelligence> skills;
  final bool isLoading;
  final String? error;

  CareerDnaState copyWith({
    List<SkillIntelligence>? skills,
    bool? isLoading,
    String? error,
  }) {
    return CareerDnaState(
      skills: skills ?? this.skills,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CareerDnaNotifier extends AsyncNotifier<CareerDnaState> {
  @override
  Future<CareerDnaState> build() async {
    final memoryEngine = ref.watch(memoryEngineProvider);
    final skillMemories = await memoryEngine.getByCategory(BookCategory.skills);
    
    final skills = <SkillIntelligence>[];
    
    for (final memory in skillMemories) {
      final name = memory.content['name'] ?? 'Unknown Skill';
      final evidenceCount = (memory.content['evidenceCount'] as int?) ?? 1;
      final confidence = memory.confidence;
      
      const recencyFactor = 0.95; 
      final proficiency = (evidenceCount * 0.1 * recencyFactor * confidence).clamp(0.0, 1.0);
      
      final trend = _calculateTrend(memory);

      skills.add(SkillIntelligence(
        name: name,
        proficiency: proficiency,
        confidence: confidence,
        evidenceCount: evidenceCount,
        verificationLevel: memory.content['verificationLevel'] ?? 'verified',
        growthTrend: trend,
        lastUsed: DateTime.tryParse(memory.content['lastUsed'] ?? ''),
        marketRelevance: (memory.content['marketRelevance'] as num?)?.toDouble() ?? 0.7,
      ));
    }

    skills.sort((a, b) => b.proficiency.compareTo(a.proficiency));

    return CareerDnaState(skills: skills);
  }

  String _calculateTrend(KnightMemory memory) {
    final trendValue = (memory.content['trendValue'] as num?) ?? 0;
    if (trendValue > 0) return 'improving';
    if (trendValue < 0) return 'declining';
    return 'stable';
  }
}

final careerDnaControllerProvider = AsyncNotifierProvider<CareerDnaNotifier, CareerDnaState>(
  CareerDnaNotifier.new,
);
