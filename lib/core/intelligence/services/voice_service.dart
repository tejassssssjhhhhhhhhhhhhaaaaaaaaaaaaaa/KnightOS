import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../knight_context_models.dart';

/// Interaction mode for the voice system.
enum VoiceMode { idle, listening, processing, speaking, ambient }

/// Emotional/Functional tone for the AI voice.
enum VoiceTone { gentle, professional, urgent, friendly, calm }

/// State for the Voice Service.
class VoiceState {
  const VoiceState({
    this.mode = VoiceMode.idle,
    this.lastTranscribedText = '',
    this.noiseLevel = 0.0,
    this.currentTone = VoiceTone.friendly,
  });

  final VoiceMode mode;
  final String lastTranscribedText;
  final double noiseLevel; // 0.0 to 1.0
  final VoiceTone currentTone;

  VoiceState copyWith({
    VoiceMode? mode,
    String? lastTranscribedText,
    double? noiseLevel,
    VoiceTone? currentTone,
  }) {
    return VoiceState(
      mode: mode ?? this.mode,
      lastTranscribedText: lastTranscribedText ?? this.lastTranscribedText,
      noiseLevel: noiseLevel ?? this.noiseLevel,
      currentTone: currentTone ?? this.currentTone,
    );
  }
}

/// Unified service for Speech-to-Text and Text-to-Speech orchestration.
class VoiceService extends Notifier<VoiceState> {
  @override
  VoiceState build() => const VoiceState();

  /// Starts listening for user speech.
  Future<void> startListening() async {
    state = state.copyWith(mode: VoiceMode.listening);

    // Simulation of STT
    await Future.delayed(const Duration(seconds: 2));
    
    state = state.copyWith(
      mode: VoiceMode.processing,
      lastTranscribedText: "What is my focus for today?",
    );
  }

  /// Activates ambient noise monitoring.
  void startAmbientMonitoring() {
    state = state.copyWith(mode: VoiceMode.ambient);
    
    // Simulate ambient pulse
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (state.mode != VoiceMode.ambient) {
        timer.cancel();
        return;
      }
      state = state.copyWith(noiseLevel: (state.noiseLevel + 0.1) % 0.4);
    });
  }

  /// Synthesizes speech from the given text.
  Future<void> speak(String text, {required KnightContext context}) async {
    final tone = _inferTone(context);
    state = state.copyWith(mode: VoiceMode.speaking, currentTone: tone);

    await Future.delayed(Duration(milliseconds: text.length * 50));

    state = state.copyWith(mode: VoiceMode.idle);
  }

  VoiceTone _inferTone(KnightContext context) {
    if (context.energyLevel == 'Low') return VoiceTone.calm;
    if (context.mood == 'Focused') return VoiceTone.professional;
    if (context.weather.contains('Storm')) return VoiceTone.gentle;
    return VoiceTone.friendly;
  }

  void stop() {
    state = state.copyWith(mode: VoiceMode.idle);
  }
}
