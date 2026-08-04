import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import 'controllers/finance_advisor_controller.dart';
import 'widgets/finance_advisor_widgets.dart';

class FinanceAdvisorScreen extends ConsumerStatefulWidget {
  const FinanceAdvisorScreen({super.key});

  @override
  ConsumerState<FinanceAdvisorScreen> createState() => _FinanceAdvisorScreenState();
}

class _FinanceAdvisorScreenState extends ConsumerState<FinanceAdvisorScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
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
    final state = ref.watch(financeAdvisorProvider);

    return KnightPageScaffold(
      title: 'Finance Advisor',
      showBackButton: true,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(24),
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                final msg = state.messages[index];
                return AdvisorChatBubble(message: msg);
              },
            ),
          ),
          if (state.isProcessing)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: LinearProgressIndicator(minHeight: 2),
            ),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Ask anything about your money...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white24),
              ),
              onSubmitted: (val) => _handleSend(),
            ),
          ),
          IconButton(
            onPressed: _handleSend,
            icon: const Icon(Icons.send_rounded, color: Colors.blueAccent),
          ),
        ],
      ),
    );
  }

  void _handleSend() {
    if (_controller.text.isEmpty) return;
    ref.read(financeAdvisorProvider.notifier).sendQuery(_controller.text);
    _controller.clear();
    _scrollToBottom();
  }
}
