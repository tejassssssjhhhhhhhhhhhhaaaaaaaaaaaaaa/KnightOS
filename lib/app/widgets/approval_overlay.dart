import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/design_constants.dart';
import '../../core/intelligence/domain/approval_models.dart';
import '../../core/intelligence/providers/intelligence_providers.dart';

class ApprovalOverlay extends ConsumerWidget {
  const ApprovalOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingApprovalsProvider);

    return pendingAsync.when(
      data: (requests) {
        if (requests.isEmpty) return const SizedBox.shrink();
        
        final request = requests.last; // Show most recent one

        return Positioned.fill(
          child: Container(
            color: Colors.black.withValues(alpha: 0.8),
            padding: const EdgeInsets.symmetric(horizontal: DesignSpacing.xl),
            child: Center(
              child: _ApprovalCard(request: request),
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _ApprovalCard extends ConsumerWidget {
  const _ApprovalCard({required this.request});
  final ApprovalRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engine = ref.read(autonomousEngineProvider);

    return Card(
      color: DesignColors.surfaceHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _getRiskColor().withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.security_rounded, color: _getRiskColor(), size: 20),
                const SizedBox(width: 8),
                Text(
                  'APPROVAL REQUIRED',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: _getRiskColor(), letterSpacing: 2.0),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              request.actionDescription,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: DesignColors.white05,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'KNIGHT REASONING',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.white24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    request.reasoning,
                    style: const TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => engine.resolveApproval(request.id, ApprovalStatus.denied),
                    child: const Text('DENY'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => engine.resolveApproval(request.id, ApprovalStatus.approved),
                    style: FilledButton.styleFrom(backgroundColor: _getRiskColor(), foregroundColor: Colors.white),
                    child: const Text('APPROVE'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getRiskColor() {
    switch (request.riskLevel) {
      case ApprovalRisk.low: return DesignColors.success;
      case ApprovalRisk.medium: return DesignColors.accentBlue;
      case ApprovalRisk.high: return DesignColors.warning;
      case ApprovalRisk.critical: return DesignColors.error;
    }
  }
}
