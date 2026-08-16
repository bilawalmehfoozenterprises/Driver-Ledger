import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../viewmodels/backfill_review_notifier.dart';

/// Editable card for a single Backfill review row: expected fee, amount
/// paid, and the derived payment status.
class BackfillRowCard extends StatefulWidget {
  final BackfillReviewRow row;
  final ValueChanged<double> onExpectedFeeChanged;
  final ValueChanged<double> onAmountPaidChanged;

  const BackfillRowCard({
    super.key,
    required this.row,
    required this.onExpectedFeeChanged,
    required this.onAmountPaidChanged,
  });

  @override
  State<BackfillRowCard> createState() => _BackfillRowCardState();
}

class _BackfillRowCardState extends State<BackfillRowCard> {
  late final TextEditingController _expectedFeeController;
  late final TextEditingController _amountPaidController;

  @override
  void initState() {
    super.initState();
    _expectedFeeController = TextEditingController(
      text: widget.row.expectedFee.toStringAsFixed(0),
    );
    _amountPaidController = TextEditingController(
      text: widget.row.amountPaid.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _expectedFeeController.dispose();
    _amountPaidController.dispose();
    super.dispose();
  }

  String _monthName(int month) => DateFormat('MMMM').format(DateTime(2024, month));

  Color _statusColor(String status, ColorScheme colorScheme) {
    switch (status) {
      case 'Paid':
        return colorScheme.primary;
      case 'Partial':
        return colorScheme.tertiary;
      case 'Unpaid':
        return colorScheme.error;
      default:
        return colorScheme.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final status = widget.row.status;

    return Material(
      color: colorScheme.surfaceContainerLow,
      borderRadius: .circular(16),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${_monthName(widget.row.month)} ${widget.row.year}',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(status, colorScheme).withValues(alpha: 0.1),
                    borderRadius: .circular(8),
                  ),
                  child: Text(
                    status,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: _statusColor(status, colorScheme),
                      fontWeight: .bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _expectedFeeController,
                    keyboardType: .number,
                    decoration: const InputDecoration(
                      labelText: 'Expected Fee (Rs.)',
                    ),
                    onChanged: (value) {
                      final fee = double.tryParse(value);
                      if (fee != null) widget.onExpectedFeeChanged(fee);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _amountPaidController,
                    keyboardType: .number,
                    decoration: const InputDecoration(
                      labelText: 'Amount Paid (Rs.)',
                    ),
                    onChanged: (value) {
                      final amount = double.tryParse(value);
                      if (amount != null) widget.onAmountPaidChanged(amount);
                    },
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
