import 'package:flutter/material.dart';

class VoiceService {
  const VoiceService();

  Future<String> captureSpeech({String? prompt}) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return prompt ??
        'Voice processing is currently initializing. Please speak clearly.';
  }

  Future<void> requestPermissions(BuildContext context) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    // Implementation pending speech_to_text package integration.
  }
}
