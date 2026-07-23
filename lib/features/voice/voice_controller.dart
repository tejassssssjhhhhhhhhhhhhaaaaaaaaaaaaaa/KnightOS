import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'domain/voice_models.dart';
import 'voice_repository.dart';
import 'voice_service.dart';

class VoiceController extends Notifier<VoiceSession?> {
  VoiceController({VoiceRepository? repository, VoiceService? service})
      : _repository = repository ?? VoiceRepository(),
        _service = service ?? const VoiceService();

  final VoiceRepository _repository;
  final VoiceService _service;

  @override
  VoiceSession? build() => null;

  String? get currentTranscript => state?.transcript;

  Future<void> captureSpeech({String? prompt}) async {
    final transcript = await _service.captureSpeech(prompt: prompt);
    final session = VoiceSession(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      transcript: transcript,
      createdAt: DateTime.now(),
    );
    state = session;
    await _repository.saveMemory(
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

final voiceControllerProvider = NotifierProvider<VoiceController, VoiceSession?>(VoiceController.new);
