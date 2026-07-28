import 'package:flutter/material.dart';
import '../../../../core/design_system/widgets/knight_card.dart';
import '../../domain/import_provider.dart';

class ImportSourceCard extends StatelessWidget {
  const ImportSourceCard({
    required this.provider,
    required this.onImport,
    super.key,
  });

  final ImportProvider provider;
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    return KnightFeatureCard(
      title: provider.displayName,
      subtitle: provider.description,
      icon: provider.icon,
      accentColor: provider.accentColor,
      onTap: onImport,
    );
  }
}
