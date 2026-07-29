import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/knight_page_scaffold.dart';
import '../widgets/voice_waveform.dart';
import '../../core/intelligence/providers/intelligence_providers.dart';
import '../../core/intelligence/services/voice_service.dart';
import '../../core/design_system/design_constants.dart';
import '../../core/intelligence/knight_context_provider.dart';

class VoiceCaptureScreen extends ConsumerStatefulWidget {
  const VoiceCaptureScreen({super.key});

  @override
  ConsumerState<VoiceCaptureScreen> createState() => _VoiceCaptureScreenState();
}

class _VoiceCaptureScreenState extends ConsumerState<VoiceCaptureScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleVoiceAction() async {
    final voiceService = ref.read(voiceServiceProvider.notifier);
    final voiceState = ref.read(voiceServiceProvider);
    final contextAsync = ref.read(currentContextNotifierProvider);
    
    if (voiceState.mode == VoiceMode.idle) {
      await voiceService.startListening();
      _controller.text = ref.read(voiceServiceProvider).lastTranscribedText;
    } else if (voiceState.mode == VoiceMode.processing) {
      final context = contextAsync.value;
      if (context != null) {
        // Trigger AI Response
        final result = await ref.read(knightCognitionProvider).processRequest(_controller.text);
        await voiceService.speak(result.response, context: context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final voiceState = ref.watch(voiceServiceProvider);
    final voiceService = ref.read(voiceServiceProvider.notifier);

    return KnightPageScaffold(
      title: 'Voice Interaction',
      showBackButton: true,
      body: Padding(
        padding: const EdgeInsets.all(DesignSpacing.l),
        child: Column(
          children: [
            const Spacer(),
            
            // 1. Dynamic Waveform
            VoiceWaveform(
              isActive: voiceState.mode == VoiceMode.listening || 
                        voiceState.mode == VoiceMode.speaking,
            ),
            
            const SizedBox(height: DesignSpacing.xl),
            
            // 2. Status Label
            Text(
              _getStatusLabel(voiceState.mode),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: DesignColors.accentBlue,
                letterSpacing: 2.0,
              ),
            ),
            
            const SizedBox(height: DesignSpacing.m),
            
            // 3. Live Transcript
            if (voiceState.mode != VoiceMode.idle)
              Container(
                padding: const EdgeInsets.all(DesignSpacing.m),
                decoration: BoxDecoration(
                  color: DesignColors.white05,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _controller.text.isEmpty ? 'Listening...' : _controller.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),

            const Spacer(),
            
            // 4. Action Button
            IconButton.filled(
              onPressed: voiceState.mode == VoiceMode.speaking ? () => voiceService.stop() : _handleVoiceAction,
              iconSize: 48,
              padding: const EdgeInsets.all(24),
              icon: Icon(
                voiceState.mode == VoiceMode.speaking ? Icons.stop_rounded :
                voiceState.mode == VoiceMode.idle ? Icons.mic_rounded : Icons.psychology_rounded,
              ),
            ),
            
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  String _getStatusLabel(VoiceMode mode) {
    switch (mode) {
      case VoiceMode.idle: return 'READY';
      case VoiceMode.listening: return 'LISTENING';
      case VoiceMode.processing: return 'THINKING';
      case VoiceMode.speaking: return 'KNIGHT SPEAKING';
      case VoiceMode.ambient: return 'AMBIENT MONITORING';
    }
  }
}
