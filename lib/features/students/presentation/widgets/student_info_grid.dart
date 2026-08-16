import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/enums/enums.dart';
import '../../data/models/student.dart';

/// Compact label/value grid of a student's contact and enrollment details.
class StudentInfoGrid extends StatelessWidget {
  final Student student;

  const StudentInfoGrid({super.key, required this.student});

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
    final route = [
      if (student.pickupLocation != null) student.pickupLocation,
      if (student.dropoffLocation != null) student.dropoffLocation,
    ].join(' → ');

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          _InfoRow(label: 'Parent', value: student.parentName ?? 'Not provided'),
          _InfoRow(label: 'Phone', value: student.parentPhone ?? 'No phone number'),
          _InfoRow(
            label: 'Fee',
            value: 'Rs. ${student.monthlyFee.toStringAsFixed(0)}/month',
          ),
          _InfoRow(label: 'Shift', value: _shiftLabel(student.shift)),
          _InfoRow(
            label: 'Joined',
            value: DateFormat('dd MMM yyyy').format(student.joinDate),
          ),
          if (route.isNotEmpty) _InfoRow(label: 'Route', value: route),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: .w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
