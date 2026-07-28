import 'package:flutter/material.dart';

class KnightProgressIndicator extends StatelessWidget {
  const KnightProgressIndicator({
    required this.value,
    this.height = 6,
    this.color,
    this.backgroundColor,
    super.key,
  });

  final double value;
  final double height;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolvedColor = color ?? theme.colorScheme.primary;
    final resolvedBackgroundColor =
        backgroundColor ?? resolvedColor.withValues(alpha: 0.1);

    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: LinearProgressIndicator(
        value: value,
        minHeight: height,
        backgroundColor: resolvedBackgroundColor,
        valueColor: AlwaysStoppedAnimation<Color>(resolvedColor),
      ),
    );
  }
}
