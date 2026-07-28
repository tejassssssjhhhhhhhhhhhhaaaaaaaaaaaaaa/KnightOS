import 'package:flutter/material.dart';
import '../../../core/design_system/design_constants.dart';

enum VaultCategory {
  books('Books', Icons.auto_stories_rounded, DesignColors.knowledge),
  pdfs('PDFs', Icons.picture_as_pdf_rounded, DesignColors.health),
  notes('Notes', Icons.description_rounded, DesignColors.focus),
  images('Images', Icons.image_rounded, DesignColors.travel),
  voice('Voice Notes', Icons.mic_none_rounded, DesignColors.achievements),
  articles('Articles', Icons.article_rounded, DesignColors.secondary),
  certificates('Certificates', Icons.verified_rounded, DesignColors.finance),
  archives('Archives', Icons.inventory_2_rounded, Colors.white24);

  const VaultCategory(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

class VaultItem {
  const VaultItem({
    required this.id,
    required this.title,
    required this.category,
    required this.addedAt,
    this.tags = const [],
    this.isFavorite = false,
    this.isLinkedToTimeline = false,
    this.thumbnailUrl,
    this.fileSize,
  });

  final String id;
  final String title;
  final VaultCategory category;
  final DateTime addedAt;
  final List<String> tags;
  final bool isFavorite;
  final bool isLinkedToTimeline;
  final String? thumbnailUrl;
  final String? fileSize;

  static List<VaultItem> get samples => [
    VaultItem(
      id: 'v1',
      title: 'Principia Mathematica',
      category: VaultCategory.books,
      addedAt: DateTime.now().subtract(const Duration(hours: 2)),
      tags: ['logic', 'foundation'],
      isFavorite: true,
      fileSize: '4.2 MB',
    ),
    VaultItem(
      id: 'v2',
      title: 'Blood Panel Results July 2026',
      category: VaultCategory.pdfs,
      addedAt: DateTime.now().subtract(const Duration(days: 1)),
      tags: ['health', 'biometrics'],
      isLinkedToTimeline: true,
      fileSize: '1.1 MB',
    ),
    VaultItem(
      id: 'v3',
      title: 'Idea: Architecture Rebirth',
      category: VaultCategory.notes,
      addedAt: DateTime.now().subtract(const Duration(days: 3)),
      tags: ['knight-os', 'planning'],
      isFavorite: true,
    ),
    VaultItem(
      id: 'v4',
      title: 'Macro Interview with Sam',
      category: VaultCategory.voice,
      addedAt: DateTime.now().subtract(const Duration(days: 5)),
      tags: ['interview', 'research'],
      fileSize: '12.4 MB',
    ),
    VaultItem(
      id: 'v5',
      title: 'Cloud Compute Architecture',
      category: VaultCategory.articles,
      addedAt: DateTime.now().subtract(const Duration(days: 12)),
      tags: ['tech', 'backend'],
    ),
  ];
}
