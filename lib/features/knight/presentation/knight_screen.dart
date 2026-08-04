import 'package:flutter/material.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/design_constants.dart';

class KnightScreen extends StatelessWidget {
  const KnightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KnightPageScaffold(
      title: 'Knight AI',
      showBackButton: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.psychology_rounded, size: 80, color: DesignColors.accentPurple),
            const SizedBox(height: 24),
            Text(
              'Neural Engine Active',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            const Text(
              'Autonomous reasoning and cognitive analysis functional.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38),
            ),
          ],
        ),
      ),
    );
  }
}
