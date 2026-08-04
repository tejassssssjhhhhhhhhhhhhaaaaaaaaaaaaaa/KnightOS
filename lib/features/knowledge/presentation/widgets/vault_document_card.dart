import 'package:flutter/material.dart';
import '../../../../core/design_system/design_constants.dart';
import '../../../../core/domain/models/models.dart';

class VaultDocumentCard extends StatelessWidget {
  const VaultDocumentCard({required this.item, this.onTap, super.key});

  final Document item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: DesignSpacing.m,
        vertical: DesignSpacing.s,
      ),
      decoration: BoxDecoration(
        color: DesignColors.surface,
        borderRadius: BorderRadius.circular(DesignRadius.l),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DesignRadius.l),
          child: Padding(
            padding: const EdgeInsets.all(DesignSpacing.m),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 60,
                  decoration: BoxDecoration(
                    color: item.category.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(DesignRadius.s),
                    border: Border.all(
                      color: item.category.color.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Icon(
                    item.category.icon,
                    color: item.category.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: DesignSpacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            item.category.label.toUpperCase(),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: DesignColors.accentBlue,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 8,
                                  letterSpacing: 1.0,
                                ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item.fileSize ?? '0 records',
                            style: const TextStyle(
                              color: Colors.white24,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Relationship Badges
                      Row(
                        children: [
                          _buildMiniBadge(Icons.link_rounded, 'Woven'),
                          const SizedBox(width: 8),
                          _buildMiniBadge(Icons.auto_awesome_rounded, 'AI Indexed'),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: Colors.white10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 8, color: Colors.white24),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 7, color: Colors.white24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
