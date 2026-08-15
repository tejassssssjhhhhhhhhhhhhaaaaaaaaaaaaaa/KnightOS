import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../core/router/router_providers.dart';
import '../data/memory_knight_repository.dart';
import '../domain/knight_conversation.dart';
import '../domain/knight_message.dart';
import '../domain/knight_repository.dart';
import '../domain/knight_state.dart';
import '../../../core/intelligence/domain/memory_metadata.dart';
import '../../../core/intelligence/domain/memory_version.dart';

import '../../../core/providers/mission_providers.dart';
import '../../../core/domain/entities/mission.dart';

/// Provider for the [KnightRepository].
final knightRepositoryProvider = Provider<KnightRepository>((ref) {
  final memoryEngine = ref.watch(memoryEngineProvider);
  return MemoryKnightRepository(memoryEngine: memoryEngine);
});

/// Provider for the Knight state.
final knightProvider = AsyncNotifierProvider<KnightController, KnightState>(
  KnightController.new,
);

/// Controller for managing the Knight conversation experience.
class KnightController extends AsyncNotifier<KnightState> {
  late final KnightRepository _repository;

  @override
  Future<KnightState> build() async {
    _repository = ref.watch(knightRepositoryProvider);
    final conversations = await _repository.getConversations();

    // Default to the latest conversation or create a new one
    final active = conversations.firstOrNull ?? KnightConversation.empty;

    return KnightState(
      activeConversation: active,
      conversations: conversations,
    );
  }

  /// Sends a message from the user.
  Future<void> sendMessage(String text) async {
    final current = state.value;
    if (current == null || text.trim().isEmpty) return;

    final userMessage = KnightMessage(
      role: KnightMessageRole.user,
      content: text.trim(),
    );

    final updatedActive = current.activeConversation.copyWith(
      messages: [...current.activeConversation.messages, userMessage],
      lastUpdatedAt: DateTime.now(),
    );

    state = AsyncValue.data(
      current.copyWith(activeConversation: updatedActive, isLoading: true),
    );

    await _repository.saveConversation(updatedActive);

    try {
      // Process through Cognitive Layer
      final cognition = ref.read(knightCognitionProvider);
      final history = updatedActive.messages.take(10).map((m) => '${m.role.name}: ${m.content}').toList();
      
      final currentModule = ref.read(currentModuleProvider);
      final currentScreen = ref.read(currentLocationProvider);

      final result = await cognition.processRequest(
        text, 
        history: history,
        currentModule: currentModule,
        currentScreen: currentScreen,
      );

      state = AsyncValue.data(state.value!.copyWith(lastTrace: result.trace));

      // Handle structured response metadata (like navigation)
      String cleanResponse = result.response;
      String? navigateTo;
      if (cleanResponse.contains('[NAVIGATE:')) {
        final match = RegExp(r'\[NAVIGATE:(.+?)\]').firstMatch(cleanResponse);
        if (match != null) {
          navigateTo = match.group(1);
          cleanResponse = cleanResponse.replaceFirst(match.group(0)!, '').trim();
        }
      }

      // Handle AI Actions
      if (cleanResponse.contains('[ACTION:CREATE_TASK:')) {
        final match = RegExp(r'\[ACTION:CREATE_TASK:(.+?)\]').firstMatch(cleanResponse);
        if (match != null) {
          final taskTitle = match.group(1)!;
          await ref.read(missionServiceProvider).createMission(
            title: taskTitle,
            type: MissionType.task,
            owningDomain: 'system',
            priority: MissionPriority.medium,
          );
          cleanResponse = cleanResponse.replaceFirst(match.group(0)!, '').trim();
        }
      }

      await receiveMessage(
        cleanResponse,
        metadata: {
          'intent': result.trace.intent.name,
          'navigateTo': navigateTo,
          'evidence': result.trace.evidence.map((e) => {
            'source': e.source,
            'timestamp': e.timestamp.toIso8601String(),
            'metadata': e.metadata,
          }).toList(),
        },
      );
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      await receiveMessage(
        "I'm sorry, I encountered an internal error while processing your request. Please check your connection or try again later.",
        role: KnightMessageRole.assistant,
      );
    }
  }

  /// Receives a message from the assistant (or system).
  Future<void> receiveMessage(
    String text, {
    KnightMessageRole role = KnightMessageRole.assistant,
    Map<String, dynamic> metadata = const {},
  }) async {
    final current = state.value;
    if (current == null) return;

    final assistantMessage = KnightMessage(
      role: role, 
      content: text,
      metadata: metadata,
    );

    final updatedActive = current.activeConversation.copyWith(
      messages: [...current.activeConversation.messages, assistantMessage],
      lastUpdatedAt: DateTime.now(),
    );

    final conversations = await _repository.getConversations();
    final index = conversations.indexWhere((c) => c.id == updatedActive.id);
    final updatedList = List<KnightConversation>.from(conversations);
    if (index != -1) {
      updatedList[index] = updatedActive;
    } else {
      updatedList.add(updatedActive);
    }

    state = AsyncValue.data(
      current.copyWith(
        activeConversation: updatedActive,
        conversations: updatedList,
        isLoading: false,
      ),
    );

    await _repository.saveConversation(updatedActive);
  }

  /// Injects a message from the system (e.g. Discovery Engine).
  Future<void> injectSystemMessage(
    String text, {
    Map<String, dynamic>? metadata,
  }) async {
    final current = state.value;
    if (current == null) return;

    final msg = KnightMessage(
      role: KnightMessageRole.assistant,
      content: text,
      metadata: metadata ?? {},
    );

    final updatedActive = current.activeConversation.copyWith(
      messages: [...current.activeConversation.messages, msg],
      lastUpdatedAt: DateTime.now(),
    );

    state = AsyncValue.data(
      current.copyWith(activeConversation: updatedActive),
    );

    await _repository.saveConversation(updatedActive);
  }

  /// Starts a new conversation.
  Future<void> startNewConversation() async {
    final newConv = KnightConversation.empty;
    final current = state.value;
    if (current == null) return;

    state = AsyncValue.data(current.copyWith(activeConversation: newConv));
  }

  /// Switches to a specific conversation.
  Future<void> loadConversation(String id) async {
    final current = state.value;
    if (current == null) return;

    final conv = current.conversations.firstWhereOrNull((c) => c.id == id);
    if (conv != null) {
      state = AsyncValue.data(current.copyWith(activeConversation: conv));
    }
  }

  /// PROMOTION: Confirms an inferred memory.
  Future<void> confirmKnowledge(String memoryId) async {
    final memoryEngine = ref.read(memoryEngineProvider);
    final memory = await memoryEngine.getLatest(memoryId);
    if (memory == null) return;

    final updated = memory.copyWith(
      metadata: memory.metadata.copyWith(
        verified: true,
        knowledgeState: KnowledgeState.userConfirmed,
        confidence: 1.0,
      ),
      version: memory.version.copyWith(
        versionNumber: memory.version.versionNumber + 1,
        changeType: ChangeType.evolution,
        reasoning: 'User explicitly confirmed inference.',
      ),
    );

    await memoryEngine.save(updated);
    await injectSystemMessage('Knowledge confirmed. Context anchor updated.');
  }

  /// CORRECTION: Rejects an inferred memory.
  Future<void> rejectKnowledge(String memoryId) async {
    final memoryEngine = ref.read(memoryEngineProvider);
    final memory = await memoryEngine.getLatest(memoryId);
    if (memory == null) return;

    final updated = memory.copyWith(
      metadata: memory.metadata.copyWith(
        verified: true, // It's verified as WRONG
        knowledgeState: KnowledgeState.userCorrected,
        confidence: 1.0,
      ),
      version: memory.version.copyWith(
        versionNumber: memory.version.versionNumber + 1,
        changeType: ChangeType.evolution,
        reasoning: 'User explicitly rejected inference.',
      ),
    );

    await memoryEngine.save(updated);
    await injectSystemMessage(
      'Understood. Assumption purged from active reasoning.',
    );
  }

  /// Deletes a specific conversation.
  Future<void> deleteConversation(String id) async {
    await _repository.deleteConversation(id);
    final conversations = await _repository.getConversations();

    if (state.value?.activeConversation.id == id) {
      final active = conversations.firstOrNull ?? KnightConversation.empty;
      state = AsyncValue.data(
        state.value!.copyWith(
          activeConversation: active,
          conversations: conversations,
        ),
      );
    } else {
      state = AsyncValue.data(
        state.value!.copyWith(conversations: conversations),
      );
    }
  }

  /// Clears the current active conversation messages.
  Future<void> clearConversation() async {
    final current = state.value;
    if (current == null) return;

    final updatedActive = current.activeConversation.copyWith(
      messages: [],
      lastUpdatedAt: DateTime.now(),
    );

    await _repository.saveConversation(updatedActive);

    final conversations = await _repository.getConversations();
    state = AsyncValue.data(
      current.copyWith(
        activeConversation: updatedActive,
        conversations: conversations,
      ),
    );
  }
}
