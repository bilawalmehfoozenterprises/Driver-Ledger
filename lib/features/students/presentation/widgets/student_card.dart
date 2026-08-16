import 'package:flutter/material.dart';

import '../../../../core/enums/enums.dart';
import '../../../../shared/widgets/status_tag.dart';
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

    return ListTile(
      onTap: isInactive ? null : onTap,
      leading: CircleAvatar(
        backgroundColor: colorScheme.primaryContainer,
        child: Text(
          student.name.isEmpty ? '?' : student.name[0].toUpperCase(),
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onPrimaryContainer,
            fontWeight: .bold,
          ),
        ),
      ),
      title: Text(
        student.name,
        style: theme.textTheme.titleMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        student.parentPhone ?? 'No phone number',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Column(
        mainAxisSize: .min,
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
          StatusTag(label: _shiftLabel(student.shift)),
        ],
      ),
    );
  }
}
