import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';
import '../../../../core/intelligence/domain/memory_metadata.dart';
import '../../../../core/intelligence/domain/memory_domain.dart';
import '../../../../core/design_system/design_constants.dart';
import 'memory_detail_sheet.dart';

class MemoryListItem extends StatelessWidget {
  const MemoryListItem({required this.memory, super.key});
  final MemoryTableData memory;

  @override
  Widget build(BuildContext context) {
    final domain = MemoryDomain.fromId(memory.domainId);
    final state = KnowledgeState.values.byName(memory.knowledgeState);
    final color = _getStateColor(state);

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => MemoryDetailSheet(memory: memory),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: DesignColors.white05)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: domain.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(domain.icon, color: domain.color, size: 16),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    memory.summary ?? memory.type.toUpperCase(),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        memory.source.toUpperCase(),
                        style: const TextStyle(fontSize: 9, color: Colors.white24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('MMM dd, HH:mm').format(memory.effectiveAt),
                        style: const TextStyle(fontSize: 9, color: DesignColors.white10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildStateIndicator(state, color),
          ],
        ),
      ),
    );
  }

  Widget _buildStateIndicator(KnowledgeState state, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        state.name.toUpperCase(),
        style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  Color _getStateColor(KnowledgeState state) {
    switch (state) {
      case KnowledgeState.observed: return Colors.blueAccent;
      case KnowledgeState.inferred: return Colors.purpleAccent;
      case KnowledgeState.userConfirmed: return Colors.greenAccent;
      case KnowledgeState.userCorrected: return Colors.orangeAccent;
      case KnowledgeState.needsReview: return Colors.deepOrangeAccent;
      case KnowledgeState.userRejected: return Colors.redAccent;
      case KnowledgeState.deprecated: return Colors.white10;
    }
  }
}
