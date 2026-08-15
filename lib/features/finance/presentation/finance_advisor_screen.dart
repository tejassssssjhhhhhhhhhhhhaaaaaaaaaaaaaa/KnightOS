import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/internal/storage/drift/knight_database.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import 'controllers/finance_advisor_controller.dart';
import 'widgets/finance_advisor_widgets.dart';
import 'widgets/transaction_explorer_widgets.dart';
import '../domain/finance_advisor_models.dart';

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
      actions: [
        IconButton(
          onPressed: state.messages.isEmpty ? null : () => _showClearConfirm(),
          icon: const Icon(Icons.delete_sweep_rounded, size: 20),
          tooltip: 'Clear History',
        ),
      ],
      body: Column(
        children: [
          Expanded(
            child: state.messages.isEmpty 
              ? _buildEmptyState()
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(24),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final msg = state.messages[index];
                    return AdvisorChatBubble(
                      message: msg,
                      onCopy: () {
                        Clipboard.setData(ClipboardData(text: msg.text));
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
                      },
                      onViewEvidence: (TransactionData tx) {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (context) => TransactionDetailSheet(tx: tx),
                        );
                      },
                    );
                  },
                ),
          ),
          if (state.isProcessing)
            _buildProcessingIndicator(),
          _buildInput(state),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.assistant_rounded, size: 64, color: Colors.white10),
          const SizedBox(height: 24),
          const Text('Your Financial Strategist', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          const Text('Ask about your spending, income, or trends.', style: TextStyle(color: Colors.white24)),
          const SizedBox(height: 32),
          _buildQuickPrompt('What was my latest transaction?'),
          _buildQuickPrompt('How much did I spend this month?'),
          _buildQuickPrompt('Show me my Amazon orders.'),
        ],
      ),
    );
  }

  Widget _buildQuickPrompt(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: OutlinedButton(
        onPressed: () {
          _controller.text = text;
          _handleSend();
        },
        style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.blueAccent)),
      ),
    );
  }

  Widget _buildProcessingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const Expanded(child: LinearProgressIndicator(minHeight: 2, color: Colors.blueAccent)),
          const SizedBox(width: 16),
          TextButton(
            onPressed: () => ref.read(financeAdvisorProvider.notifier).cancel(),
            child: const Text('STOP', style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(FinanceAdvisorState state) {
    return Container(
      padding: EdgeInsets.only(
        left: 24, 
        right: 24, 
        top: 16, 
        bottom: MediaQuery.of(context).padding.bottom + 16
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0A),
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: !state.isProcessing,
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
            onPressed: state.isProcessing ? null : _handleSend,
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

  void _showClearConfirm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Clear History?'),
        content: const Text('This will delete the current conversation. Knowledge memories will not be affected.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          FilledButton(
            onPressed: () {
              ref.read(financeAdvisorProvider.notifier).clearHistory();
              Navigator.pop(context);
            }, 
            child: const Text('CLEAR')
          ),
        ],
      ),
    );
  }
}
