import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/enums/enums.dart';
import '../../data/models/student.dart';

/// Card showing a student's contact and enrollment details.
class StudentInfoCard extends StatelessWidget {
  final Student student;

  const StudentInfoCard({super.key, required this.student});

  String _shiftLabel(Shift shift) {
    switch (shift) {
      case Shift.morning:
        return 'Morning';
      case Shift.afternoon:
        return 'Afternoon';
      case Shift.both:
        return 'Both';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(student.name, style: theme.textTheme.titleLarge),
                      Text(
                        'Parent: ${student.parentName ?? 'Not provided'}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Icon(
                  Icons.phone,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  student.parentPhone ?? 'No phone number',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.monetization_on,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  'Rs. ${student.monthlyFee.toStringAsFixed(0)}/month',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  _shiftLabel(student.shift),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  'Joined: ${DateFormat('dd MMM yyyy').format(student.joinDate)}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            if (student.pickupLocation != null ||
                student.dropoffLocation != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      [
                        if (student.pickupLocation != null)
                          'Pickup: ${student.pickupLocation}',
                        if (student.dropoffLocation != null)
                          'Drop: ${student.dropoffLocation}',
                      ].join(' • '),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
