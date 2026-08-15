import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/design_system/knight_tokens.dart';
import 'knight_controller.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/message_composer.dart';

class KnightScreen extends ConsumerStatefulWidget {
  const KnightScreen({super.key});

  @override
  ConsumerState<KnightScreen> createState() => _KnightScreenState();
}

class _KnightScreenState extends ConsumerState<KnightScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(knightProvider);

    return KnightPageScaffold(
      title: 'Assistant',
      showBackButton: true,
      actions: [
        IconButton(
          onPressed: () => ref.read(knightProvider.notifier).clearConversation(),
          icon: const Icon(Icons.delete_sweep_rounded, size: 20),
          tooltip: 'Clear History',
        ),
      ],
      body: Column(
        children: [
          Expanded(
            child: stateAsync.when(
              data: (state) {
                final messages = state.activeConversation.messages;
                if (messages.isEmpty) {
                  return _buildEmptyState();
                }
                
                // P0: Scroll to bottom whenever messages update
                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(24),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ChatBubble(message: messages[index]);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
          stateAsync.maybeWhen(
            data: (state) => state.isLoading ? _buildLoadingIndicator() : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
          MessageComposer(
            onSend: (text) => ref.read(knightProvider.notifier).sendMessage(text),
            isLoading: stateAsync.maybeWhen(
              data: (state) => state.isLoading,
              orElse: () => false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.auto_awesome_rounded, size: 80, color: DesignColors.accentBlue),
          const SizedBox(height: 32),
          Text(
            'How can I help you today?',
            style: KnightTokens.headline.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 12),
          const Text(
            'I have access to your finance, travel, goals, and more.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38),
          ),
          const SizedBox(height: 40),
          _buildQuickPrompt('What did I spend this month?'),
          _buildQuickPrompt('What are my upcoming trips?'),
          _buildQuickPrompt('Show my active goals.'),
        ],
      ),
    );
  }

  Widget _buildQuickPrompt(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: OutlinedButton(
        onPressed: () => ref.read(knightProvider.notifier).sendMessage(text),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text(text, style: const TextStyle(fontSize: 13, color: DesignColors.accentBlue)),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: LinearProgressIndicator(
        minHeight: 2,
        backgroundColor: Colors.transparent,
        valueColor: AlwaysStoppedAnimation<Color>(DesignColors.accentBlue),
      ),
    );
  }
}
