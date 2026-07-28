import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/design_constants.dart';

class KnowledgeDashboardScreen extends ConsumerWidget {
  const KnowledgeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return KnightPageScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildTabs(context),
            const SizedBox(height: 32),
            _buildSearchBar(context),
            const SizedBox(height: 32),
            _buildKnowledgeList(context),
            const SizedBox(height: 140),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: DesignColors.accentBlue,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        Text('Knowledge', style: Theme.of(context).textTheme.headlineMedium),
        IconButton(
          icon: const Icon(Icons.more_vert_rounded),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildTabs(BuildContext context) {
    final tabs = ['Notes', 'Bookmarks', 'Courses', 'Ideas'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.map((tab) {
          final isActive = tab == 'Notes';
          return Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              tab,
              style: TextStyle(
                color: isActive ? Colors.black : Colors.white38,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search notes...',
        prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Colors.white24),
        suffixIcon: const Icon(Icons.tune_rounded, size: 20, color: DesignColors.accentBlue),
        fillColor: DesignColors.surfaceHigh,
      ),
    );
  }

  Widget _buildKnowledgeList(BuildContext context) {
    final items = [
      _KItem('Interview Preparation', 'Today, 4:30 PM', Icons.description_outlined, DesignColors.accentBlue),
      _KItem('Networking Basics', 'Jul 26, 2025', Icons.language_rounded, DesignColors.accentPurple),
      _KItem('System Design Notes', 'Jul 16, 2025', Icons.memory_rounded, DesignColors.accentCyan),
      _KItem('Python Basics', 'Jul 14, 2025', Icons.code_rounded, DesignColors.success),
      _KItem('React Interview Questions', 'Jul 12, 2025', Icons.article_outlined, DesignColors.warning),
    ];

    return Column(
      children: items.map((item) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: DesignColors.surfaceHigh.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: DesignColors.white05),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, color: item.color, size: 20),
          ),
          title: Text(item.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          subtitle: Text(item.date, style: const TextStyle(fontSize: 11, color: Colors.white24)),
          trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white10),
          onTap: () {},
        ),
      )).toList(),
    );
  }
}

class _KItem {
  const _KItem(this.title, this.date, this.icon, this.color);
  final String title;
  final String date;
  final IconData icon;
  final Color color;
}
