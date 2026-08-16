import 'package:flutter/material.dart';

import '../../data/models/monthly_record.dart';
import '../../data/models/student.dart';

({Color band, Color onBand}) studentBandColors(
  ColorScheme colorScheme,
  MonthlyRecord? record,
) {
  if (record == null || record.isFullyPaid) {
    return (band: colorScheme.primary, onBand: colorScheme.onPrimary);
  }
  if (record.totalPaid > 0) {
    return (band: colorScheme.tertiary, onBand: colorScheme.onTertiary);
  }
  return (band: colorScheme.error, onBand: colorScheme.onError);
}

String studentBandStatusLine(MonthlyRecord? record) {
  if (record == null) return 'No payment record yet';
  if (record.isFullyPaid) return 'Fully paid this month';
  final due = record.balance.toStringAsFixed(0);
  return record.totalPaid > 0
      ? 'Rs. $due remaining this month'
      : 'Rs. $due due this month';
}

/// Content of the collapsible header band: avatar, name, and the current
/// month's payment status. Used as a [SliverAppBar.flexibleSpace] background.
class StudentHeaderBand extends StatelessWidget {
  final Student student;
  final MonthlyRecord? currentRecord;

  const StudentHeaderBand({
    super.key,
    required this.student,
    required this.currentRecord,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final colors = studentBandColors(colorScheme, currentRecord);

    final topInset = MediaQuery.of(context).padding.top + kToolbarHeight;

    return Container(
      width: double.infinity,
      color: colors.band,
      padding: EdgeInsets.fromLTRB(20, topInset, 20, 20),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisAlignment: .end,
        children: [
          Text(
            student.name,
            style: theme.textTheme.titleLarge?.copyWith(
              color: colors.onBand,
              fontWeight: .bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Text(
            studentBandStatusLine(currentRecord),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colors.onBand,
              fontWeight: .w600,
            ),
          ),
        ],
      ),
    );
  }
}
