import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../brain/knight_brain.dart';
import '../services/ai_service.dart';
import 'storage_providers.dart';
import '../intelligence/providers/intelligence_providers.dart';

/// Provider for the AI service used across the application.
final aiServiceProvider = Provider<AiService>((ref) {
  final contextEngine = ref.watch(contextEngineProvider);
  return AiService(contextEngine: contextEngine);
});

/// Provider for the KnightBrain orchestrator.
final knightBrainProvider = Provider<KnightBrain>((ref) {
  final engine = ref.watch(storageEngineProvider);
  final userRepository = ref.watch(userRepositoryProvider);
  final authRepository = ref.watch(authenticationRepositoryProvider);

  return KnightBrain(
    engine: engine,
    userRepository: userRepository,
    authenticationRepository: authRepository,
  );
});
