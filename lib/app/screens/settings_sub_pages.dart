import 'package:flutter/material.dart';
import '../widgets/knight_page_scaffold.dart';

class SettingsSubPage extends StatelessWidget {
  const SettingsSubPage({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return KnightPageScaffold(
      title: title,
      showBackButton: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction_rounded, size: 64, color: Colors.white24),
            const SizedBox(height: 24),
            Text(
              '$title control is currently managed by the autonomous core. Manual overrides will be available in future intelligence updates.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white38, fontSize: 13, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
