import 'package:flutter/foundation.dart';
import '../../../core/intelligence/domain/cognitive_models.dart';
import 'knight_conversation.dart';

/// Represents the global state of the Knight feature.
@immutable
class KnightState {
  const KnightState({
    required this.activeConversation,
    this.conversations = const [],
    this.isLoading = false,
    this.error,
    this.lastTrace,
  });

  /// The conversation currently being viewed or edited.
  final KnightConversation activeConversation;

  /// List of all historical conversations.
  final List<KnightConversation> conversations;

  /// Whether a background operation (like sending a message) is in progress.
  final bool isLoading;

  /// Optional error message from the last operation.
  final String? error;

  /// The reasoning trace of the latest response for explainability.
  final ReasoningTrace? lastTrace;

  KnightState copyWith({
    KnightConversation? activeConversation,
    List<KnightConversation>? conversations,
    bool? isLoading,
    String? error,
    ReasoningTrace? lastTrace,
  }) {
    return KnightState(
      activeConversation: activeConversation ?? this.activeConversation,
      conversations: conversations ?? this.conversations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lastTrace: lastTrace ?? this.lastTrace,
    );
  }
}
