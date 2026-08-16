import 'package:flutter/material.dart';

import '../../data/models/monthly_record.dart';

/// Card with the record-payment and record-vacation action buttons.
class MonthlyActionsCard extends StatelessWidget {
  final MonthlyRecord record;
  final VoidCallback onRecordPayment;
  final VoidCallback onRecordVacation;

  const MonthlyActionsCard({
    super.key,
    required this.record,
    required this.onRecordPayment,
    required this.onRecordVacation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              'Actions',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: .bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: record.isFullyPaid ? null : onRecordPayment,
                icon: const Icon(Icons.payment),
                label: Text(
                  record.isFullyPaid ? 'Fully Paid' : 'Record Payment',
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onRecordVacation,
                icon: const Icon(Icons.beach_access),
                label: const Text('Record Vacation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
