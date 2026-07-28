import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/voice/voice_controller.dart';
import '../../core/intelligence/providers/intelligence_providers.dart';
import '../widgets/knight_page_scaffold.dart';

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

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(voiceControllerProvider);
    final controller = ref.read(voiceControllerProvider.notifier);

    if (session != null && _controller.text.isEmpty) {
      _controller.text = session.transcript;
    }

    return KnightPageScaffold(
      title: 'Voice capture',
      showBackButton: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Capture your thoughts naturally',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Speak naturally and save a voice memory. Future AI extraction will turn this into structured context.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () async {
                await controller.captureSpeech(prompt: '');
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Voice memory captured.')),
                );
              },
              icon: const Icon(Icons.mic_rounded),
              label: const Text('Capture voice'),
            ),
            const SizedBox(height: 24),
            if (session != null) ...[
              Text(
                'Transcript',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _controller,
                maxLines: 6,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Edit transcript before saving',
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () async {
                  final text = _controller.text;
                  await controller.updateTranscript(text);
                  if (!context.mounted) return;
                  
                  // Trigger Cognition for "Voice Assistant" effect
                  ref.read(knightCognitionProvider).processRequest(text);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cognition engine processing voice input...')),
                  );
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.psychology_rounded),
                label: const Text('Process with Knight'),
              ),
            ] else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'No transcript yet. Press the microphone to begin.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
