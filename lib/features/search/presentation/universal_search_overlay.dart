import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design_system/knight_tokens.dart';

import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../core/intelligence/domain/search_models.dart';

class UniversalSearchOverlay extends ConsumerStatefulWidget {
  const UniversalSearchOverlay({super.key});

  static void show(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Search',
      barrierColor: Colors.black.withValues(alpha: 0.4),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => const UniversalSearchOverlay(),
    );
  }

  @override
  ConsumerState<UniversalSearchOverlay> createState() => _UniversalSearchOverlayState();
}

class _UniversalSearchOverlayState extends ConsumerState<UniversalSearchOverlay> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _results = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearch(String query) async {
    if (query.length < 2) {
      setState(() => _results = []);
      return;
    }
    
    final service = ref.read(searchServiceProvider);
    final collection = await service.query(query);
    
    setState(() {
      _results = collection.results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          color: KnightTokens.midnight.withValues(alpha: 0.8),
          child: SafeArea(
            child: Column(
              children: [
                _buildSearchBar(),
                const Divider(color: Colors.white10, height: 1),
                Expanded(child: _buildResults()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 40, 28, 28),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: true,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Search your life...',
                hintStyle: TextStyle(color: Colors.white10),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                fillColor: Colors.transparent,
              ),
              onChanged: _onSearch,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white38, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_results.isEmpty && _controller.text.length >= 2) {
      return const Center(child: Text('No results found.', style: TextStyle(color: Colors.white24)));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      itemCount: _results.length,
      itemBuilder: (context, i) {
        final r = _results[i] as SearchResult;
        final icon = _getIcon(r.sourceMemory?.category.name);
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: Colors.white.withValues(alpha: 0.05),
              child: Icon(icon, color: Colors.white38, size: 18),
            ),
            title: Text(
              r.title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              r.sourceMemory?.category.name.toUpperCase() ?? 'KNOWLEDGE',
              style: const TextStyle(fontSize: 10, color: Colors.white12, fontWeight: FontWeight.w900, letterSpacing: 1.0),
            ),
            onTap: () {
              Navigator.pop(context);
              // Future: Route mapping for each category
            },
          ),
        );
      },
    );
  }

  IconData _getIcon(String? category) {
    if (category == 'finance') return Icons.account_balance_wallet_rounded;
    if (category == 'health') return Icons.favorite_rounded;
    if (category == 'travel') return Icons.flight_takeoff_rounded;
    return Icons.psychology_outlined;
  }
}
