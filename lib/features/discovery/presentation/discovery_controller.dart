import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../core/intelligence/engines/verification_engine.dart';
import '../domain/discovery_models.dart';
import '../../knight/presentation/knight_controller.dart';

class DiscoveryState {
  const DiscoveryState({this.currentMission, this.isProcessing = false});

  final dynamic
  currentMission; // Can be DiscoveryQuestion or VerificationMission
  final bool isProcessing;

  DiscoveryState copyWith({dynamic currentMission, bool? isProcessing}) {
    return DiscoveryState(
      currentMission: currentMission ?? this.currentMission,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

class DiscoveryController extends Notifier<DiscoveryState> {
  @override
  DiscoveryState build() {
    return const DiscoveryState();
  }

  Future<void> initiateNextInquiry() async {
    state = state.copyWith(isProcessing: true);
    final engine = ref.read(discoveryEngineProvider);
    final knightNotifier = ref.read(knightProvider.notifier);

    final mission = await engine.getNextMission();

    if (mission != null) {
      state = state.copyWith(currentMission: mission, isProcessing: false);

      if (mission is VerificationMission) {
        // Verification Flow
        knightNotifier.injectSystemMessage(
          'I have analyzed your temporal footprint and identified a high-confidence pattern. Can you verify this reconstruction?',
          metadata: {
            'type': 'verification',
            'memoryId': mission.memory.memoryId,
          },
        );
      } else if (mission is DiscoveryQuestion) {
        // Standard Discovery Flow
        knightNotifier.injectSystemMessage(
          'INQUIRY: ${mission.text}',
          metadata: {'type': 'discovery', 'questionId': mission.id},
        );
      }
    } else {
      state = state.copyWith(isProcessing: false);
      knightNotifier.injectSystemMessage(
        'All active constellations are currently stabilized.',
      );
    }
  }

  Future<void> submitAnswer(String answer) async {
    final mission = state.currentMission;
    if (mission is! DiscoveryQuestion) return;

    state = state.copyWith(isProcessing: true);
    final engine = ref.read(discoveryEngineProvider);
    await engine.answerQuestion(mission, answer);

    state = state.copyWith(currentMission: null, isProcessing: false);
    Future.delayed(const Duration(seconds: 1), () => initiateNextInquiry());
  }
}

final discoveryProvider = NotifierProvider<DiscoveryController, DiscoveryState>(
  DiscoveryController.new,
);
