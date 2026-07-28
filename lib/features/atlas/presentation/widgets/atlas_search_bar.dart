import 'package:flutter/material.dart';
import '../../../../core/design_system/design_constants.dart';

class AtlasSearchBar extends StatelessWidget {
  const AtlasSearchBar({required this.onChanged, super.key});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignSpacing.m),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: DesignColors.surface,
          borderRadius: BorderRadius.circular(DesignRadius.m),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: DesignSpacing.m),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, color: Colors.white24, size: 20),
            const SizedBox(width: DesignSpacing.m),
            Expanded(
              child: TextField(
                onChanged: onChanged,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Search your memories...',
                  hintStyle: TextStyle(color: Colors.white24),
                  border: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
