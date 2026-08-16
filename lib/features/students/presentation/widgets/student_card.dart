import 'package:flutter/material.dart';

import '../../../../core/enums/enums.dart';
import '../../data/models/student.dart';

/// Card showing a single student's summary in the students list.
class StudentCard extends StatelessWidget {
  final Student student;
  final bool isInactive;
  final VoidCallback? onTap;

  const StudentCard({
    super.key,
    required this.student,
    this.isInactive = false,
    this.onTap,
  });

  String _shiftLabel(Shift shift) {
    switch (shift) {
      case .morning:
        return 'Morning';
      case .afternoon:
        return 'Afternoon';
      case .both:
        return 'Both';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: InkWell(
        onTap: isInactive ? null : onTap,
        borderRadius: .circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Opacity(
            opacity: isInactive ? 0.6 : 1.0,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            student.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            student.parentPhone ?? 'No phone number',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: .end,
                      children: [
                        Text(
                          'Rs. ${student.monthlyFee.toStringAsFixed(0)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: .bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer,
                            borderRadius: .circular(8),
                          ),
                          child: Text(
                            _shiftLabel(student.shift),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
