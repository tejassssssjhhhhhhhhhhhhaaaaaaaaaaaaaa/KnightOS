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
                            item.category.label,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Colors.white24,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 9,
                                ),
                          ),
                          if (item.fileSize != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 2,
                              height: 2,
                              color: Colors.white10,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              item.fileSize!,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Colors.white24,
                                    fontSize: 9,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                if (item.isFavorite)
                  const Icon(
                    Icons.star_rounded,
                    size: 16,
                    color: DesignColors.achievements,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
