import 'package:flutter/material.dart';

/// Empty state shown when there are no students yet.
class StudentsEmptyState extends StatelessWidget {
  final String title;
  final String message;

  const StudentsEmptyState({
    super.key,
    this.title = 'No Students Yet',
    this.message = 'Add your first student to start tracking payments.',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Icon(Icons.people_outlined, size: 80, color: colorScheme.primary),
            const SizedBox(height: 24),
            Text(
              title,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: .center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
