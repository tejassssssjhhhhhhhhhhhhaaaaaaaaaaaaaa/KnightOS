import 'package:flutter/material.dart';

class VoiceService {
  const VoiceService();

  Future<String> captureSpeech({String? prompt}) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return prompt ?? 'TODO: connect speech_to_text and capture natural speech';
  }

  Future<void> requestPermissions(BuildContext context) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    // TODO: request microphone permission when package is added.
  }
}
