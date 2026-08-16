import 'package:flutter/material.dart';

/// A small, non-interactive label pill used to show a status or category
/// (e.g. a shift or payment status) inline with other content.
class StatusTag extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;

  const StatusTag({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.secondaryContainer,
        borderRadius: .circular(8),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: textColor ?? colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }
}
