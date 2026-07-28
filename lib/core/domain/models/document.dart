import 'package:flutter/material.dart';
import '../../design_system/design_constants.dart';

enum DocumentCategory {
  book('Book', Icons.auto_stories_rounded, DesignColors.knowledge),
  pdf('PDF', Icons.picture_as_pdf_rounded, DesignColors.health),
  note('Note', Icons.description_rounded, DesignColors.focus),
  image('Image', Icons.image_rounded, DesignColors.travel),
  voice('Voice Note', Icons.mic_none_rounded, DesignColors.achievements),
  certificate('Certificate', Icons.verified_rounded, DesignColors.finance),
  identity('Identity', Icons.badge_rounded, DesignColors.primary),
  career('Career', Icons.business_center_rounded, DesignColors.focus),
  medical('Medical', Icons.medical_services_rounded, DesignColors.health),
  finance('Finance', Icons.account_balance_rounded, DesignColors.finance),
  other('Other', Icons.inventory_2_rounded, Colors.white24);

  const DocumentCategory(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

class Document {
  const Document({
    required this.id,
    required this.title,
    required this.category,
    required this.addedAt,
    this.fileHash,
    this.fileSize,
    this.extension,
    this.tags = const [],
    this.isFavorite = false,
    this.thumbnailUrl,
    this.sourcePath,
  });

  final String id;
  final String title;
  final DocumentCategory category;
  final DateTime addedAt;
  final String? fileHash;
  final String? fileSize;
  final String? extension;
  final List<String> tags;
  final bool isFavorite;
  final String? thumbnailUrl;
  final String? sourcePath;

  static List<Document> get samples => [
    Document(
      id: 'v1',
      title: 'Principia Mathematica',
      category: DocumentCategory.book,
      addedAt: DateTime.now().subtract(const Duration(hours: 2)),
      tags: ['logic', 'foundation'],
      isFavorite: true,
      fileSize: '4.2 MB',
    ),
    Document(
      id: 'v2',
      title: 'Blood Panel Results July 2026',
      category: DocumentCategory.pdf,
      addedAt: DateTime.now().subtract(const Duration(days: 1)),
      tags: ['health', 'biometrics'],
      fileSize: '1.1 MB',
    ),
    Document(
      id: 'v3',
      title: 'Idea: Architecture Rebirth',
      category: DocumentCategory.note,
      addedAt: DateTime.now().subtract(const Duration(days: 3)),
      tags: ['knight-os', 'planning'],
      isFavorite: true,
    ),
    Document(
      id: 'v4',
      title: 'Macro Interview with Sam',
      category: DocumentCategory.voice,
      addedAt: DateTime.now().subtract(const Duration(days: 5)),
      tags: ['interview', 'research'],
      fileSize: '12.4 MB',
    ),
  ];
}
