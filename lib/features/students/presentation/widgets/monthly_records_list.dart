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

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        return MonthCard(
          record: record,
          onTap: () => onRecordTap(record),
        );
      },
    );
  }
}
