import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/monthly_record.dart';

/// Plain, action-first summary of the current month's payment status,
/// with Record Payment / Record Vacation buttons right on the card.
class ThisMonthCard extends StatelessWidget {
  final MonthlyRecord record;
  final VoidCallback onRecordPayment;
  final VoidCallback onRecordVacation;
  final VoidCallback onViewHistory;

  const ThisMonthCard({
    super.key,
    required this.record,
    required this.onRecordPayment,
    required this.onRecordVacation,
    required this.onViewHistory,
  });

  String _monthName(int month) {
    return DateFormat('MMMM').format(DateTime(2024, month));
  }

  Color _statusColor(ColorScheme colorScheme) {
    switch (record.status) {
      case 'Paid':
        return colorScheme.primary;
      case 'Partial':
        return colorScheme.tertiary;
      default:
        return colorScheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = _statusColor(colorScheme);

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              '${_monthName(record.month)} ${record.year}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: .bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.circle, size: 10, color: statusColor),
                const SizedBox(width: 6),
                Text(
                  record.isFullyPaid
                      ? 'Paid in full'
                      : 'Rs. ${record.balance.toStringAsFixed(0)} still owed',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: statusColor,
                    fontWeight: .w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: record.isFullyPaid ? null : onRecordPayment,
                    icon: const Icon(Icons.payments),
                    label: const Text('Record Payment'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onRecordVacation,
                    icon: const Icon(Icons.beach_access),
                    label: const Text('Record Vacation'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onViewHistory,
                    icon: const Icon(Icons.history),
                    label: const Text('Payment History'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
