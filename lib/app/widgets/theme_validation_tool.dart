import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/knight_theme_provider.dart';

class ThemeValidationTool extends ConsumerWidget {
  const ThemeValidationTool({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
      top: 100,
      right: 20,
      child: Material(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              _btn(ref, '06', 6),
              _btn(ref, '12', 12),
              _btn(ref, '18', 18),
              _btn(ref, '22', 22),
              _btn(ref, 'R', null),
            ],
          ),
        ),
      ),
    );
  }

  Widget _btn(WidgetRef ref, String label, int? hour) {
    return TextButton(
      style: TextButton.styleFrom(minimumSize: const Size(30, 30), padding: EdgeInsets.zero),
      onPressed: () => ref.read(simulatedHourProvider.notifier).set(hour),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 10)),
    );
  }
}
