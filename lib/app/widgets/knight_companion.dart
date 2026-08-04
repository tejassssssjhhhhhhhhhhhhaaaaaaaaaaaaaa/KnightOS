import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/design_constants.dart';
import '../../core/design_system/widgets/knight_circuit_shield.dart';
import '../../core/intelligence/services/voice_service.dart';
import '../../core/intelligence/providers/intelligence_providers.dart';
import '../../core/theme/knight_theme_provider.dart';
import '../../features/search/presentation/universal_search_overlay.dart';

class KnightCompanion extends ConsumerStatefulWidget {
  const KnightCompanion({super.key});

  @override
  ConsumerState<KnightCompanion> createState() => _KnightCompanionState();
}

class _KnightCompanionState extends ConsumerState<KnightCompanion> with TickerProviderStateMixin {
  Offset _position = const Offset(300, 600); 
  bool _isDragging = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    
    // P0: Avoid infinite animations during widget tests to prevent pumpAndSettle timeouts.
    if (!kDebugMode || !Platform.environment.containsKey('FLUTTER_TEST')) {
       _animationController.repeat();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _position += details.delta;
      _isDragging = true;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    final size = MediaQuery.of(context).size;
    setState(() {
      // Snap to nearest edge
      final targetX = _position.dx < size.width / 2 ? 16.0 : size.width - 80.0;
      _position = Offset(targetX, _position.dy.clamp(100.0, size.height - 200.0));
      _isDragging = false;
    });
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final voiceState = ref.watch(voiceServiceProvider);
    final period = ref.watch(currentPeriodProvider);
    final perception = ref.watch(perceptionEngineProvider);
    
    return AnimatedPositioned(
      duration: _isDragging ? Duration.zero : const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      left: _position.dx,
      top: _position.dy,
      width: 64,
      height: 64,
      child: Semantics(
        label: 'Knight Companion',
        child: GestureDetector(
          onPanUpdate: _onDragUpdate,
          onPanEnd: _onDragEnd,
          onTap: () => _handleTap(voiceState.mode),
          onLongPress: _showQuickActions,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return KnightCircuitShield(
                size: 64,
                period: period,
                state: _getShieldState(voiceState.mode, perception),
                animationValue: _animationController.value,
              );
            },
          ),
        ),
      ),
    );
  }

  ShieldState _getShieldState(VoiceMode mode, String perception) {
    if (mode == VoiceMode.listening) return ShieldState.listening;
    if (mode == VoiceMode.processing) return ShieldState.thinking;
    if (mode == VoiceMode.speaking) return ShieldState.speaking;
    if (perception != 'stationary') return ShieldState.perception;
    return ShieldState.idle;
  }

  void _handleTap(VoiceMode mode) {
    if (mode == VoiceMode.idle) {
      ref.read(voiceServiceProvider.notifier).startListening();
    } else {
      ref.read(voiceServiceProvider.notifier).stop();
    }
  }

  void _showQuickActions() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: DesignColors.surfaceHigh.withValues(alpha: 0.8),
            borderRadius: DesignRadius.sheet,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('KNIGHT COMMANDS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2.0, color: Colors.white24)),
              const SizedBox(height: 24),
              _ActionGrid(),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 4,
      mainAxisSpacing: 20,
      children: [
        _QuickAction(icon: Icons.mic_rounded, label: 'Voice'),
        _QuickAction(icon: Icons.edit_note_rounded, label: 'Note'),
        _QuickAction(icon: Icons.qr_code_scanner_rounded, label: 'Scan'),
        _QuickAction(icon: Icons.add_task_rounded, label: 'Task'),
        _QuickAction(icon: Icons.account_balance_wallet_rounded, label: 'Expense'),
        _QuickAction(icon: Icons.fitness_center_rounded, label: 'Workout'),
        _QuickAction(
          icon: Icons.search_rounded, 
          label: 'Search',
          onTap: () {
            Navigator.pop(context);
            UniversalSearchOverlay.show(context);
          },
        ),
        _QuickAction(icon: Icons.visibility_off_rounded, label: 'Hide'),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label, this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withValues(alpha: 0.05),
            child: Icon(icon, color: Colors.white70, size: 20),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 9, color: Colors.white38)),
        ],
      ),
    );
  }
}
