import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../knight_context_provider.dart';
import '../knight_context_models.dart';
import '../providers/intelligence_providers.dart';
import '../domain/approval_models.dart';
import '../../providers/focus_mode_provider.dart';
import '../../providers/relaxation_mode_provider.dart';
import '../../internal/utils/knight_logger.dart';

/// Watches reasoning for mode transition suggestions and initiates human-in-the-loop approval.
class ModeSwitchAgent {
  ModeSwitchAgent(this.ref) {
    _listenToContext();
  }

  final Ref ref;

  void _listenToContext() {
    ref.listen(currentContextNotifierProvider, (previous, next) {
      final context = next.value;
      if (context == null || context.reasoning == null) return;

      for (final rec in context.reasoning!.recommendations) {
        if (rec.id == 'rec-mode-relaxation') {
           _triggerRelaxationApproval(context, rec.description);
        } else if (rec.id == 'rec-mode-focus') {
           _triggerFocusApproval(context, rec.description);
        }
      }
    });
  }

  bool _isRequestingRelaxation = false;
  Future<void> _triggerRelaxationApproval(KnightContext context, String reasoning) async {
    if (_isRequestingRelaxation) return;
    _isRequestingRelaxation = true;

    KnightLogger.info('[MODE AGENT] Requesting Relaxation Mode approval...');
    
    final service = ref.read(autonomousServiceProvider);
    final result = await service.requestSystemAction(
      id: 'action-switch-relaxation',
      action: 'Activate Relaxation Mode',
      reasoning: reasoning,
      risk: ApprovalRisk.medium,
    );

    if (result == ApprovalStatus.approved) {
       await ref.read(relaxationModeProvider.notifier).set(true);
       KnightLogger.info('[MODE AGENT] Relaxation Mode approved and activated.');
    }
    
    _isRequestingRelaxation = false;
  }

  bool _isRequestingFocus = false;
  Future<void> _triggerFocusApproval(KnightContext context, String reasoning) async {
    if (_isRequestingFocus) return;
    _isRequestingFocus = true;

    KnightLogger.info('[MODE AGENT] Requesting Focus Mode approval...');
    
    final service = ref.read(autonomousServiceProvider);
    final result = await service.requestSystemAction(
      id: 'action-switch-focus',
      action: 'Enter Focus Mode',
      reasoning: reasoning,
      risk: ApprovalRisk.low,
    );

    if (result == ApprovalStatus.approved) {
       ref.read(focusModeProvider.notifier).set(true);
       KnightLogger.info('[MODE AGENT] Focus Mode approved and activated.');
    }
    
    _isRequestingFocus = false;
  }
}

final modeSwitchAgentProvider = Provider<ModeSwitchAgent>((ref) {
  return ModeSwitchAgent(ref);
});
