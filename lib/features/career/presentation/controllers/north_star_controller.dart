import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/entities/strategic_models.dart';
import '../../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../../core/intelligence/domain/memory_category.dart';
import '../../../../core/intelligence/engines/strategic/gap_analysis_engine.dart';
import '../../../../core/intelligence/domain/knight_memory.dart';
import '../../../../core/intelligence/domain/memory_domain.dart';

class NorthStarState {
  const NorthStarState({
    this.vision,
    this.northStars = const [],
    this.gapReports = const {},
  });

  final LifeVision? vision;
  final List<NorthStar> northStars;
  final Map<String, GapReport> gapReports;

  NorthStarState copyWith({
    LifeVision? vision,
    List<NorthStar>? northStars,
    Map<String, GapReport>? gapReports,
  }) {
    return NorthStarState(
      vision: vision ?? this.vision,
      northStars: northStars ?? this.northStars,
      gapReports: gapReports ?? this.gapReports,
    );
  }
}

class NorthStarNotifier extends AsyncNotifier<NorthStarState> {
  @override
  Future<NorthStarState> build() async {
    final memoryEngine = ref.watch(memoryEngineProvider);
    final gapEngine = GapAnalysisEngine(memoryEngine: memoryEngine);

    final visionMemories = await memoryEngine.getByCategory(BookCategory.identity);
    final visionMemory = visionMemories.isEmpty ? _createDefaultVisionMemory() : visionMemories.firstWhere(
      (m) => m.tags.contains('life_vision'),
      orElse: () => _createDefaultVisionMemory(),
    );

    final vision = LifeVision(
      id: visionMemory.memoryId,
      title: visionMemory.content['title'] ?? 'My Life Purpose',
      purpose: visionMemory.content['purpose'],
      coreValues: List<String>.from(visionMemory.content['coreValues'] ?? []),
      createdAt: visionMemory.effectiveAt,
    );

    final careerMemories = await memoryEngine.getByCategory(BookCategory.career);
    final northStars = careerMemories
        .where((m) => m.tags.contains('north_star'))
        .map((m) => NorthStar(
              id: m.memoryId,
              lifeVisionId: vision.id,
              title: m.content['title'] ?? 'Untitled Goal',
              domain: 'career',
              targetState: m.content['targetState'],
              progress: (m.content['progress'] as num?)?.toDouble() ?? 0.0,
              priority: (m.content['priority'] as int?) ?? 5,
              createdAt: m.effectiveAt,
            ))
        .toList();

    final gapReports = <String, GapReport>{};
    for (final ns in northStars) {
      gapReports[ns.id] = await gapEngine.analyze(ns);
    }

    return NorthStarState(
      vision: vision,
      northStars: northStars,
      gapReports: gapReports,
    );
  }

  KnightMemory _createDefaultVisionMemory() {
    return KnightMemory.create(
      memoryId: 'default-vision',
      category: BookCategory.identity,
      domain: MemoryDomain.lifeValues,
      source: MemorySource.manual,
      content: {
        'title': 'My Professional North Star',
        'purpose': 'Empowering growth through verified evidence.',
        'coreValues': ['Integrity', 'Impact', 'Continuous Learning'],
      },
      tags: ['life_vision'],
    );
  }
}

final northStarControllerProvider = AsyncNotifierProvider<NorthStarNotifier, NorthStarState>(
  NorthStarNotifier.new,
);
