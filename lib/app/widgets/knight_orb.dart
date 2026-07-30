import 'package:flutter/material.dart';
import '../../core/design_system/design_constants.dart';
import '../../features/knight/presentation/knight_screen.dart';
import '../../features/welcome/presentation/widgets/knight_helmet_logo.dart';

class KnightOrb extends StatefulWidget {
  const KnightOrb({super.key});

  @override
  State<KnightOrb> createState() => _KnightOrbState();
}

class _KnightOrbState extends State<KnightOrb> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isExpanded = !_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 1. Overlay (Full Screen AI Chat)
        if (_isExpanded)
          Positioned.fill(
            child: Material(
              color: Colors.black.withOpacity(0.9),
              child: Stack(
                children: [
                  GestureDetector(onTap: _toggle),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 100),
                      child: Container(
                        decoration: BoxDecoration(
                          color: DesignColors.surface,
                          borderRadius: DesignRadius.card,
                          border: Border.all(color: DesignColors.white05),
                          boxShadow: DesignShadows.glowBlue,
                        ),
                        child: ClipRRect(
                          borderRadius: DesignRadius.card,
                          child: const KnightScreen(),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 60,
                    right: 40,
                    child: IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white70),
                      onPressed: _toggle,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // 2. Glowing Knight Helmet FAB
        GestureDetector(
          onTap: _toggle,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: DesignColors.surfaceHigh,
                  border: Border.all(
                    color: DesignColors.accentBlue.withOpacity(0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: DesignColors.accentBlue.withOpacity(0.3 * _pulseController.value),
                      blurRadius: 20,
                      spreadRadius: 2 * _pulseController.value,
                    ),
                  ],
                ),
                child: const KnightHelmetLogo(size: 40),
              );
            },
          ),
        ),
      ],
    );
  }
}
