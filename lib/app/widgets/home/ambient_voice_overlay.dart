import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/design_constants.dart';
import '../../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../../core/intelligence/services/voice_service.dart';
import '../../../../core/internal/utils/knight_logger.dart';

class AmbientVoiceOverlay extends ConsumerWidget {
  const AmbientVoiceOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voiceState = ref.watch(voiceServiceProvider);
    final isVisible = voiceState.mode != VoiceMode.idle;
    KnightLogger.info('[UI] AmbientVoiceOverlay build() isVisible: $isVisible, mode: ${voiceState.mode}', category: KnightLogCategory.ui);

    return AnimatedSwitcher(
      duration: DesignAnimations.standard,
      child: isVisible
          ? Container(
              key: const ValueKey('voice_overlay'),
              color: Colors.black.withValues(alpha: 0.85),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _VoicePulse(
                      mode: voiceState.mode,
                      noiseLevel: voiceState.noiseLevel,
                    ),
                    const SizedBox(height: 40),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        _getModeLabel(voiceState.mode),
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2.0,
                                ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        voiceState.lastTranscribedText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),
                    IconButton(
                      onPressed: () =>
                          ref.read(voiceServiceProvider.notifier).stop(),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white38,
                        size: 32,
                      ),
                      tooltip: 'Close Voice Assistant',
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  String _getModeLabel(VoiceMode mode) {
    switch (mode) {
      case VoiceMode.listening:
        return 'LISTENING';
      case VoiceMode.processing:
        return 'THINKING';
      case VoiceMode.speaking:
        return 'SPEAKING';
      case VoiceMode.ambient:
        return 'AMBIENT MODE';
      case VoiceMode.idle:
        return '';
    }
  }
}

class _VoicePulse extends StatefulWidget {
  const _VoicePulse({required this.mode, required this.noiseLevel});
  final VoiceMode mode;
  final double noiseLevel;

  @override
  State<_VoicePulse> createState() => _VoicePulseState();
}

class _VoicePulseState extends State<_VoicePulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = 1.0 + widget.noiseLevel * 0.5;
        
        return Stack(
          alignment: Alignment.center,
          children: [
            // Ripple 1
            _Ripple(progress: _controller.value, scale: scale),
            // Ripple 2
            _Ripple(progress: (_controller.value + 0.5) % 1.0, scale: scale),
            
            // Core
            Container(
              width: 80 * scale,
              height: 80 * scale,
              decoration: BoxDecoration(
                color: DesignColors.accentBlue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: DesignColors.accentBlue.withValues(alpha: 0.5),
                    blurRadius: 20 * scale,
                    spreadRadius: 5 * scale,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Ripple extends StatelessWidget {
  const _Ripple({required this.progress, required this.scale});
  final double progress;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: (1.0 - progress) * 0.5,
      child: Container(
        width: 80 + (progress * 120 * scale),
        height: 80 + (progress * 120 * scale),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: DesignColors.accentBlue,
            width: 2,
          ),
        ),
      ),
    );
  }
}
