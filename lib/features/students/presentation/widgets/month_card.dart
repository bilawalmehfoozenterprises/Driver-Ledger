import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/monthly_record.dart';

/// Card summarizing a single month's payment record.
class MonthCard extends StatelessWidget {
  final MonthlyRecord record;
  final VoidCallback onTap;

  const MonthCard({super.key, required this.record, required this.onTap});

  String _monthName(int month) {
    return DateFormat('MMMM').format(DateTime(2024, month));
  }

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
    final now = DateTime.now();
    final isCurrentMonth = record.month == now.month && record.year == now.year;

    return Material(
      color: colorScheme.surfaceContainerLow,
      borderRadius: .circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
          child: Row(
            crossAxisAlignment: .start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${_monthName(record.month)} ${record.year}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: isCurrentMonth ? .bold : .normal,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor(
                              record.status,
                              colorScheme,
                            ).withValues(alpha: 0.1),
                            borderRadius: .circular(8),
                          ),
                          child: Text(
                            record.status,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: _statusColor(record.status, colorScheme),
                              fontWeight: .bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              'Expected',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              'Rs. ${record.expectedFee.toStringAsFixed(0)}',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        if (record.vacationDays > 0)
                          Column(
                            crossAxisAlignment: .center,
                            children: [
                              Text(
                                'Vacation',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                '${record.vacationDays} days',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.tertiary,
                                ),
                              ),
                            ],
                          ),
                        Column(
                          crossAxisAlignment: .end,
                          children: [
                            Text(
                              'Paid',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              'Rs. ${record.totalPaid.toStringAsFixed(0)}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: record.isFullyPaid
                                    ? colorScheme.primary
                                    : colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (record.deductionAmount > 0) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Deduction: Rs. ${record.deductionAmount.toStringAsFixed(0)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
