import 'package:flutter/material.dart';

import '../../data/models/monthly_record.dart';
import 'summary_row.dart';

/// Card showing the payment summary for a monthly record.
class PaymentSummaryCard extends StatelessWidget {
  final MonthlyRecord record;

  const PaymentSummaryCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              'Payment Summary',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: .bold,
              ),
            ),
            const SizedBox(height: 16),
            SummaryRow(
              label: 'Expected Fee',
              value: 'Rs. ${record.expectedFee.toStringAsFixed(0)}',
            ),
            if (record.vacationDays > 0) ...[
              const Divider(height: 24),
              SummaryRow(
                label: 'Vacation Days',
                value: '${record.vacationDays} days',
              ),
              const SizedBox(height: 8),
              SummaryRow(
                label: 'Deduction',
                value: '- Rs. ${record.deductionAmount.toStringAsFixed(0)}',
                valueColor: colorScheme.tertiary,
              ),
            ],
            const Divider(height: 24),
            SummaryRow(
              label: 'Amount Due',
              value: 'Rs. ${record.amountDue.toStringAsFixed(0)}',
              isBold: true,
            ),
            const SizedBox(height: 8),
            SummaryRow(
              label: 'Amount Paid',
              value: 'Rs. ${record.totalPaid.toStringAsFixed(0)}',
              valueColor: record.isFullyPaid ? colorScheme.primary : null,
            ),
            const Divider(height: 24),
            SummaryRow(
              label: 'Balance',
              value: 'Rs. ${record.balance.toStringAsFixed(0)}',
              isBold: true,
              valueColor: record.isFullyPaid
                  ? colorScheme.primary
                  : record.balance > 0
                  ? colorScheme.error
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
