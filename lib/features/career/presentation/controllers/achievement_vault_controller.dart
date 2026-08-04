import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/entities/evidence.dart';
import '../../../../core/providers/integration_providers.dart';
import '../../domain/career_models.dart';

class AchievementVaultState {
  const AchievementVaultState({
    this.achievements = const [],
    this.searchQuery = '',
    this.selectedCategory = 'all',
  });

  final List<Achievement> achievements;
  final String searchQuery;
  final String selectedCategory;

  AchievementVaultState copyWith({
    List<Achievement>? achievements,
    String? searchQuery,
    String? selectedCategory,
  }) {
    return AchievementVaultState(
      achievements: achievements ?? this.achievements,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class AchievementVaultNotifier extends AsyncNotifier<AchievementVaultState> {
  @override
  Future<AchievementVaultState> build() async {
    final evidenceRepository = ref.watch(evidenceRepositoryProvider);
    final allEvidence = await evidenceRepository.getAll();
    
    final achievements = allEvidence
        .where((e) => e.verificationStatus == EvidenceVerificationStatus.verified || 
                     e.verificationStatus == EvidenceVerificationStatus.trusted)
        .map((e) => Achievement(
              id: e.caid,
              title: e.originalName,
              description: e.extractionData['description'] ?? 'Verified professional achievement.',
              category: e.extractionData['category'] ?? 'milestone',
              date: e.ingestedAt,
              evidenceCaid: e.caid,
              isVerified: true,
              source: e.extractionData['source_connector'] ?? 'manual',
              tags: List<String>.from(e.extractionData['tags'] ?? []),
            ))
        .toList();
    
    return AchievementVaultState(achievements: achievements);
  }

  void search(String query) {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(searchQuery: query));
  }

  void setCategory(String category) {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(selectedCategory: category));
  }
}

final achievementVaultControllerProvider = AsyncNotifierProvider<AchievementVaultNotifier, AchievementVaultState>(
  AchievementVaultNotifier.new,
);
