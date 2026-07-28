import 'package:flutter/material.dart';
import '../../../../core/design_system/design_constants.dart';

class VaultSearchBar extends StatelessWidget {
  const VaultSearchBar({required this.onChanged, super.key});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignSpacing.m),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: DesignColors.surface,
          borderRadius: BorderRadius.circular(DesignRadius.m),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: DesignSpacing.m),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, color: Colors.white24, size: 22),
            const SizedBox(width: DesignSpacing.m),
            Expanded(
              child: TextField(
                onChanged: onChanged,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                decoration: const InputDecoration(
                  hintText: 'Search your library...',
                  hintStyle: TextStyle(color: Colors.white24),
                  border: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(DesignSpacing.xs),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.tune_rounded,
                size: 16,
                color: Colors.white38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
