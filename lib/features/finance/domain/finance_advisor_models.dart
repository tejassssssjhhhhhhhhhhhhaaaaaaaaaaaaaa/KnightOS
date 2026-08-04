import '../../../../core/internal/storage/drift/knight_database.dart';

class AdvisorMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final AdvisorResponse? response;

  AdvisorMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.response,
  });
}

class AdvisorResponse {
  final String answer;
  final String evidence;
  final double confidence;
  final String reasoning;
  final List<TransactionData> sourceTransactions;
  final List<String> relatedTimelineIds;
  final String? relatedGoalId;

  AdvisorResponse({
    required this.answer,
    required this.evidence,
    required this.confidence,
    required this.reasoning,
    this.sourceTransactions = const [],
    this.relatedTimelineIds = const [],
    this.relatedGoalId,
  });
}

class FinanceAdvisorState {
  final List<AdvisorMessage> messages;
  final bool isProcessing;

  FinanceAdvisorState({
    this.messages = const [],
    this.isProcessing = false,
  });

  FinanceAdvisorState copyWith({
    List<AdvisorMessage>? messages,
    bool? isProcessing,
  }) {
    return FinanceAdvisorState(
      messages: messages ?? this.messages,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}
