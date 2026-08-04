import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/entities/evidence.dart';
import '../../../../core/providers/integration_providers.dart';
import '../../../../core/services/evidence_review_service.dart';

class EvidenceInboxState {
  const EvidenceInboxState({
    this.items = const [],
    this.isLoading = false,
    this.filter = EvidenceVerificationStatus.pending,
  });

  final List<Evidence> items;
  final bool isLoading;
  final EvidenceVerificationStatus filter;

  EvidenceInboxState copyWith({
    List<Evidence>? items,
    bool? isLoading,
    EvidenceVerificationStatus? filter,
  }) {
    return EvidenceInboxState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      filter: filter ?? this.filter,
    );
  }
}

class EvidenceInboxNotifier extends Notifier<EvidenceInboxState> {
  @override
  EvidenceInboxState build() {
    Future.microtask(_load);
    return const EvidenceInboxState(isLoading: true);
  }

  Future<void> _load() async {
    state = state.copyWith(isLoading: true);
    final repo = ref.read(evidenceRepositoryProvider);
    final all = await repo.getAll();
    
    final filtered = all.where((e) => e.verificationStatus == state.filter).toList();
    state = state.copyWith(items: filtered, isLoading: false);
  }

  void setFilter(EvidenceVerificationStatus filter) {
    state = state.copyWith(filter: filter);
    _load();
  }

  Future<void> verify(String caid) async {
    final service = ref.read(evidenceReviewServiceProvider);
    await service.updateStatus(caid, EvidenceVerificationStatus.verified);
    _load();
  }

  Future<void> reject(String caid) async {
    final service = ref.read(evidenceReviewServiceProvider);
    await service.updateStatus(caid, EvidenceVerificationStatus.rejected);
    _load();
  }
}

final evidenceReviewServiceProvider = Provider((ref) {
  return EvidenceReviewService(ref.watch(evidenceRepositoryProvider));
});

final evidenceInboxControllerProvider =
    NotifierProvider<EvidenceInboxNotifier, EvidenceInboxState>(
      EvidenceInboxNotifier.new,
    );
