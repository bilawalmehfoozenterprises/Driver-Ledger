import 'package:flutter/material.dart';

/// Empty state shown when there are no students yet.
class StudentsEmptyState extends StatelessWidget {
  const StudentsEmptyState({super.key});

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
              'No Students Yet',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first student to start tracking payments.',
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
