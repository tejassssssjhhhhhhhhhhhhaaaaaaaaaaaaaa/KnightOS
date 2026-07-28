import 'package:flutter/material.dart';
import '../../../../core/design_system/design_constants.dart';

class VaultUploadMenu extends StatelessWidget {
  const VaultUploadMenu({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: DesignColors.background,
      shape: RoundedRectangleBorder(borderRadius: DesignRadius.sheet),
      builder: (context) => const VaultUploadMenu(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(DesignSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ingest Knowledge',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Select a source to expand your personal library.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: DesignSpacing.xl),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: DesignSpacing.m,
              crossAxisSpacing: DesignSpacing.m,
              childAspectRatio: 2.2,
              children: [
                _buildUploadOption(
                  context,
                  'PDF Document',
                  Icons.picture_as_pdf_rounded,
                  DesignColors.health,
                ),
                _buildUploadOption(
                  context,
                  'Research Book',
                  Icons.auto_stories_rounded,
                  DesignColors.knowledge,
                ),
                _buildUploadOption(
                  context,
                  'Voice Memo',
                  Icons.mic_rounded,
                  DesignColors.achievements,
                ),
                _buildUploadOption(
                  context,
                  'Web Article',
                  Icons.article_rounded,
                  DesignColors.secondary,
                ),
                _buildUploadOption(
                  context,
                  'Image/Scan',
                  Icons.image_rounded,
                  DesignColors.travel,
                ),
                _buildUploadOption(
                  context,
                  'Atomic Note',
                  Icons.description_rounded,
                  DesignColors.focus,
                ),
              ],
            ),
            const SizedBox(height: DesignSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadOption(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: DesignColors.surface,
        borderRadius: BorderRadius.circular(DesignRadius.l),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(DesignRadius.l),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: DesignSpacing.m),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: DesignSpacing.m),
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
