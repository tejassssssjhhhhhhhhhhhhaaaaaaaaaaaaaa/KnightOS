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
    final userMessage = AdvisorMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isProcessing: true,
    );

    final service = ref.read(financeAdvisorServiceProvider);
    
    try {
      final response = await service.processQuery(text, history: state.messages);
      
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

  void clearHistory() {
    state = FinanceAdvisorState();
  }
}
