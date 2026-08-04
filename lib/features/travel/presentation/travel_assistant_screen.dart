import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/design_system/widgets/entrance_fader.dart';
import 'providers/travel_providers.dart';

class TravelAssistantScreen extends ConsumerStatefulWidget {
  const TravelAssistantScreen({super.key});

  @override
  ConsumerState<TravelAssistantScreen> createState() => _TravelAssistantScreenState();
}

class _TravelAssistantScreenState extends ConsumerState<TravelAssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<_ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messages.add(const _ChatMessage(text: 'Hello! I am your Knight Travel Assistant. How can I help you explore your history today?', isUser: false));
  }

  Future<void> _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _isTyping = true;
      _controller.clear();
    });

    final ai = ref.read(travelAiProvider);
    final response = await ai.query(text);

    if (mounted) {
      setState(() {
        _messages.add(_ChatMessage(text: response, isUser: false));
        _isTyping = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return KnightPageScaffold(
      title: 'Travel Assistant',
      showBackButton: true,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: _messages.length,
              itemBuilder: (context, index) => EntranceFader(
                offset: const Offset(0, 10),
                child: _messages[index],
              ),
            ),
          ),
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.only(left: 32, bottom: 16),
              child: Align(alignment: Alignment.centerLeft, child: Text('Thinking...', style: TextStyle(color: Colors.white24, fontSize: 10))),
            ),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: DesignColors.surfaceHigh,
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Ask about your trips, destinations...',
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _handleSend(),
            ),
          ),
          IconButton(
            onPressed: _handleSend,
            icon: const Icon(Icons.send_rounded, color: DesignColors.accentBlue),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage extends StatelessWidget {
  const _ChatMessage({required this.text, required this.isUser});
  final String text;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? DesignColors.accentBlue.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isUser ? const Radius.circular(20) : const Radius.circular(4),
            bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(20),
          ),
          border: Border.all(color: isUser ? DesignColors.accentBlue.withValues(alpha: 0.3) : Colors.white10),
        ),
        child: Text(text, style: TextStyle(color: isUser ? Colors.white : Colors.white70)),
      ),
    );
  }
}
