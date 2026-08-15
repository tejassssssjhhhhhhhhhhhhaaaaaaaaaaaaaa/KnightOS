import 'package:flutter/material.dart';
import '../../../../core/intelligence/providers/journey_provider.dart';
import 'error_detail_view.dart';

class DataPipelineJourneyVisualizer extends StatelessWidget {
  const DataPipelineJourneyVisualizer({required this.journey, super.key});

  final PipelineJourney journey;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              _getSourceIcon(journey.connectorId),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    journey.connectorId.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 2),
                  ),
                  Text(
                    'RESOURCE ID: ${journey.resourceId}',
                    style: const TextStyle(color: Colors.white24, fontSize: 8),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: journey.stages.length,
          itemBuilder: (context, index) {
            final stage = journey.stages[index];
            final isLast = index == journey.stages.length - 1;
            
            return InkWell(
              onTap: stage.status == JourneyStageStatus.failed ? () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (context) => ErrorDetailView(stage: stage),
                );
              } : null,
              child: _StageItem(
                stage: stage,
                isLast: isLast,
                isFirst: index == 0,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _getSourceIcon(String id) {
    IconData icon;
    if (id.contains('gmail')) {
      icon = Icons.email_rounded;
    } else if (id.contains('calendar')) {
      icon = Icons.calendar_today_rounded;
    } else if (id.contains('drive')) {
      icon = Icons.insert_drive_file_rounded;
    } else {
      icon = Icons.hub_rounded;
    }

    return Icon(icon, color: Colors.blueAccent, size: 24);
  }
}

class _StageItem extends StatelessWidget {
  const _StageItem({
    required this.stage,
    required this.isLast,
    required this.isFirst,
  });

  final JourneyStage stage;
  final bool isLast;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(stage.status);
    final isFailed = stage.status == JourneyStageStatus.failed;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: stage.status == JourneyStageStatus.active ? Colors.white : color,
                    shape: BoxShape.circle,
                    boxShadow: stage.status == JourneyStageStatus.active || isFailed
                        ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 10, spreadRadius: 2)]
                        : null,
                  ),
                  child: stage.status == JourneyStageStatus.active
                      ? const Padding(
                          padding: EdgeInsets.all(2),
                          child: CircularProgressIndicator(
                              strokeWidth: 1, color: Colors.blueAccent))
                      : null,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      color: color.withValues(alpha: 0.2),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        stage.label.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: stage.status == JourneyStageStatus.waiting ? Colors.white24 : Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (isFailed)
                        const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 12),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stage.humanExplanation,
                    style: TextStyle(
                      fontSize: 12,
                      color: stage.status == JourneyStageStatus.waiting ? Colors.white10 : Colors.white70,
                    ),
                  ),
                  if (stage.status != JourneyStageStatus.waiting)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 16),
                      child: Text(
                        stage.technicalDetail,
                        style: const TextStyle(fontSize: 9, color: Colors.blueGrey, fontStyle: FontStyle.italic),
                      ),
                    ),
                  if (isFailed && stage.error != null)
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('TECHNICAL ERROR', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 8)),
                          const SizedBox(height: 4),
                          Text(stage.error!, style: const TextStyle(color: Colors.redAccent, fontSize: 10, fontFamily: 'monospace')),
                        ],
                      ),
                    ),
                  if (isLast) const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(JourneyStageStatus status) {
    switch (status) {
      case JourneyStageStatus.waiting:
        return Colors.white10;
      case JourneyStageStatus.active:
        return Colors.blueAccent;
      case JourneyStageStatus.completed:
        return Colors.greenAccent;
      case JourneyStageStatus.failed:
        return Colors.redAccent;
    }
  }
}
