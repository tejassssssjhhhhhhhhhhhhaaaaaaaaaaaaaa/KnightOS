import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';

class KnightScreen extends ConsumerStatefulWidget {
  const KnightScreen({super.key});

  @override
  ConsumerState<KnightScreen> createState() => _KnightScreenState();
}

class _KnightScreenState extends ConsumerState<KnightScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<_ChatMessage> _messages = [];
  bool _isThinking = false;

  @override
  void initState() {
    super.initState();
    _messages.add(
      const _ChatMessage(
        text: "Good Evening, Tejas! ✨\nHow can I assist you today?",
        isAi: true,
      ),
    );
  }

  Future<void> _sendMessage([String? text]) async {
    final messageText = text ?? _controller.text.trim();
    if (messageText.isEmpty) return;

    setState(() {
      if (text == null) _controller.clear();
      _messages.add(_ChatMessage(text: messageText, isAi: false));
      _isThinking = true;
    });

    try {
      final cognition = ref.read(knightCognitionProvider);
      final result = await cognition.processRequest(messageText);

      setState(() {
        _messages.add(_ChatMessage(text: result.response, isAi: true));
        _isThinking = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(
          _ChatMessage(text: "System reasoning error: $e", isAi: true),
        );
        _isThinking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          Expanded(
            child: _messages.length == 1 ? _buildSuggestions() : _buildChatList(),
          ),
          if (_isThinking)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          const SizedBox(height: 16),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: DesignColors.surfaceHigh,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white10),
          ),
          child: const Icon(Icons.shield_rounded, color: DesignColors.accentBlue, size: 20),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Knight AI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('Your AI Companion', style: TextStyle(fontSize: 11, color: Colors.white38)),
          ],
        ),
      ],
    );
  }

  Widget _buildSuggestions() {
    final suggestions = [
      ('Analyse my productivity', Icons.insights_rounded),
      ('Plan my tomorrow', Icons.calendar_today_rounded),
      ('How\'s my health today?', Icons.favorite_outline_rounded),
      ('Summarize my day?', Icons.auto_awesome_mosaic_rounded),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _messages.first.text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.4),
        ),
        const SizedBox(height: 32),
        ...suggestions.map((s) => Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          child: OutlinedButton.icon(
            onPressed: () => _sendMessage(s.$1),
            icon: Icon(s.$2, size: 16, color: DesignColors.accentBlue),
            label: Text(s.$1, style: const TextStyle(color: Colors.white70)),
            style: OutlinedButton.styleFrom(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              side: const BorderSide(color: DesignColors.white05),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      itemCount: _messages.length,
      itemBuilder: (context, i) {
        final m = _messages[i];
        final isAi = m.isAi;
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isAi) ...[
                const CircleAvatar(
                  radius: 14,
                  backgroundColor: DesignColors.surfaceHigh,
                  child: Icon(Icons.shield_rounded, color: DesignColors.accentBlue, size: 14),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isAi ? DesignColors.surfaceHigh : DesignColors.accentBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: isAi ? Border.all(color: DesignColors.white05) : null,
                  ),
                  child: Text(
                    m.text,
                    style: TextStyle(
                      color: isAi ? Colors.white70 : Colors.white,
                      height: 1.5,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              if (!isAi) const SizedBox(width: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: DesignColors.surfaceHigh,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Ask Knight anything...',
                border: InputBorder.none,
                filled: false,
                hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.mic_none_rounded, color: Colors.white38),
            onPressed: () {},
          ),
          Container(
            margin: const EdgeInsets.only(left: 8),
            decoration: const BoxDecoration(
              color: DesignColors.accentBlue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 20),
              onPressed: () => _sendMessage(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({required this.text, required this.isAi});
  final String text;
  final bool isAi;
}
