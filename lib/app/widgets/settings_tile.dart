import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.title,
    required this.subtitle,
    this.leading,
    this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData? leading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: leading == null ? null : Icon(leading, color: theme.colorScheme.primary),
      title: Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      trailing: onTap == null ? null : const Icon(Icons.chevron_right_outlined),
      onTap: onTap,
    );
  }
}
