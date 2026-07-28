import 'package:flutter/material.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/design_constants.dart';

class DocumentCenterScreen extends StatelessWidget {
  const DocumentCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            _buildCategoryList(context),
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
        Text('Documents', style: Theme.of(context).textTheme.headlineMedium),
        IconButton(
          icon: const Icon(Icons.more_vert_rounded),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildTabs(BuildContext context) {
    final tabs = ['All', 'Personal', 'Work', 'Finance'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.map((tab) {
          final isActive = tab == 'All';
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

  Widget _buildCategoryList(BuildContext context) {
    final categories = [
      _DocCat('ID Proof', '4 files', Icons.badge_outlined, DesignColors.accentBlue),
      _DocCat('Education', '6 files', Icons.school_outlined, DesignColors.accentPurple),
      _DocCat('Finance', '8 files', Icons.account_balance_outlined, DesignColors.finance),
      _DocCat('Work', '12 files', Icons.work_outline_rounded, DesignColors.career),
      _DocCat('Personal', '5 files', Icons.person_outline_rounded, DesignColors.success),
      _DocCat('Others', '3 files', Icons.folder_open_rounded, DesignColors.secondary),
    ];

    return Column(
      children: categories.map((cat) => Container(
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
              color: cat.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(cat.icon, color: cat.color, size: 20),
          ),
          title: Text(cat.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          subtitle: Text(cat.subtitle, style: const TextStyle(fontSize: 11, color: Colors.white24)),
          trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white10),
          onTap: () {},
        ),
      )).toList(),
    );
  }
}

class _DocCat {
  const _DocCat(this.title, this.subtitle, this.icon, this.color);
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}
