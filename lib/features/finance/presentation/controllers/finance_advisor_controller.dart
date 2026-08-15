import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/finance_advisor_models.dart';
import '../../platform/providers/finance_platform_providers.dart';
import '../../../../core/providers/database_provider.dart';
import '../../platform/sync/finance_advisor_service.dart';

final financeAdvisorServiceProvider = Provider<FinanceAdvisorService>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  final dao = ref.watch(financePlatformDaoProvider);
  return FinanceAdvisorService(db: db, dao: dao);
});

final financeAdvisorProvider = NotifierProvider<FinanceAdvisorController, FinanceAdvisorState>(
  FinanceAdvisorController.new,
);

class FinanceAdvisorController extends Notifier<FinanceAdvisorState> {
  @override
  FinanceAdvisorState build() {
    return FinanceAdvisorState();
  }

  Future<void> sendQuery(String text) async {
    if (text.isEmpty) return;
    
    final userMessage = AdvisorMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isProcessing: true,
    );

    await _process(text);
  }

  Future<void> regenerate() async {
    final lastUserMsg = state.messages.lastWhere((m) => m.isUser, orElse: () => AdvisorMessage(text: '', isUser: true, timestamp: DateTime.now()));
    if (lastUserMsg.text.isEmpty) return;

    state = state.copyWith(isProcessing: true);
    await _process(lastUserMsg.text);
  }

  Future<void> _process(String text) async {
    final service = ref.read(financeAdvisorServiceProvider);
    
    try {
      final response = await service.processQuery(text, history: state.messages);
      
      // Check if still processing (not cancelled)
      if (!state.isProcessing) return;

      final botMessage = AdvisorMessage(
        text: response.answer,
        isUser: false,
        timestamp: DateTime.now(),
        response: response,
      );

      state = state.copyWith(
        messages: [...state.messages, botMessage],
        isProcessing: false,
      );
    } catch (e) {
      if (!state.isProcessing) return;
      
      state = state.copyWith(
        isProcessing: false,
        messages: [
          ...state.messages,
          AdvisorMessage(
            text: "Error processing query: $e",
            isUser: false,
            timestamp: DateTime.now(),
          ),
        ],
      );
    }
  }

  void cancel() {
    state = state.copyWith(isProcessing: false);
  }

  void clearHistory() {
    state = FinanceAdvisorState();
  }
}
