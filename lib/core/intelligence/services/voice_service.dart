import 'dart:async';
import 'package:flutter/foundation.dart';
import '../knight_context_models.dart';

/// Interaction mode for the voice system.
enum VoiceMode { idle, listening, processing, speaking }

/// Unified service for Speech-to-Text and Text-to-Speech orchestration.
class VoiceService extends ChangeNotifier {
  VoiceService();

  VoiceMode _mode = VoiceMode.idle;
  VoiceMode get mode => _mode;

  String _lastTranscribedText = '';
  String get lastTranscribedText => _lastTranscribedText;

  /// Starts listening for user speech.
  Future<void> startListening() async {
    _mode = VoiceMode.listening;
    notifyListeners();

    // Simulation of STT
    await Future.delayed(const Duration(seconds: 2));
    _lastTranscribedText = "What is my focus for today?";
    
    _mode = VoiceMode.processing;
    notifyListeners();
  }

  /// Synthesizes speech from the given text.
  Future<void> speak(String text, {required KnightContext context}) async {
    _mode = VoiceMode.speaking;
    notifyListeners();

    // Simulation of TTS with emotional context awareness
    final tone = _getTone(context);
    debugPrint('[TTS] Speaking with $tone tone: $text');

    await Future.delayed(Duration(milliseconds: text.length * 50));

    _mode = VoiceMode.idle;
    notifyListeners();
  }

  String _getTone(KnightContext context) {
    if (context.mood.contains('Focus')) return 'Professional';
    if (context.energyLevel == 'Low') return 'Calm';
    return 'Friendly';
  }

  void stop() {
    _mode = VoiceMode.idle;
    notifyListeners();
  }
}
