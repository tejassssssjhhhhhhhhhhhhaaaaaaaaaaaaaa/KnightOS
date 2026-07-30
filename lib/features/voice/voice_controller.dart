import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/intelligence/providers/intelligence_providers.dart';
import 'domain/voice_models.dart';
import 'voice_repository.dart';

class VoiceController extends Notifier<VoiceSession?> {
  @override
  VoiceSession? build() => null;

  String? get currentTranscript => state?.transcript;

  Future<void> captureSpeech({String? prompt}) async {
    final voiceService = ref.read(voiceServiceProvider.notifier);
    final transcript = await voiceService.captureSpeech(prompt: prompt);
    
    final session = VoiceSession(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      transcript: transcript,
      createdAt: DateTime.now(),
    );
    state = session;
    
    await VoiceRepository().saveMemory(
      VoiceMemory(
        id: session.id,
        transcript: transcript,
        createdAt: session.createdAt,
        summary: 'Saved locally and ready for future context enrichment.',
      ),
    );
  }

  Future<void> updateTranscript(String transcript) async {
    final current = state;
    if (current == null) {
      return;
    }
    state = VoiceSession(
      id: current.id,
      transcript: transcript,
      createdAt: current.createdAt,
      isEdited: true,
      status: 'edited',
    );
  }
}

final voiceControllerProvider =
    NotifierProvider<VoiceController, VoiceSession?>(VoiceController.new);
