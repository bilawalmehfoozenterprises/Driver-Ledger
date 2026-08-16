import 'package:flutter/material.dart';

import '../../data/models/monthly_record.dart';
import 'month_card.dart';

/// Scrollable list of a student's monthly records.
class MonthlyRecordsList extends StatelessWidget {
  final List<MonthlyRecord> records;
  final void Function(MonthlyRecord record) onRecordTap;

  const MonthlyRecordsList({
    super.key,
    required this.records,
    required this.onRecordTap,
  });

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return const Center(child: Text('No monthly records'));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          for (final record in records) ...[
            MonthCard(record: record, onTap: () => onRecordTap(record)),
            if (record != records.last) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
