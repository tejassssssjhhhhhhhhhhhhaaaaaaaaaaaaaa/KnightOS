import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/design_constants.dart';
import '../../../../core/design_system/widgets/knight_card.dart';
import '../../../../core/domain/models/models.dart';

class AtlasTimelineCard extends StatelessWidget {
  const AtlasTimelineCard({required this.event, this.onTap, super.key});

  final TimelineEvent event;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat.Hm().format(event.timestamp);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSpacing.m,
        vertical: DesignSpacing.s,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Time Indicator
            SizedBox(
              width: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    timeStr,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Center(
                      child: Container(width: 1, color: Colors.white10),
                    ),
                  ),
                ],
              ),
            ),

            // Content Card
            Expanded(
              child: KnightFeatureCard(
                title: event.title,
                subtitle: event.subtitle ?? '',
                icon: event.category.icon,
                accentColor: event.category.color,
                onTap: onTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
