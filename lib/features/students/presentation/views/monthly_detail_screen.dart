import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../viewmodels/monthly_detail_notifier.dart';
import '../widgets/monthly_actions_card.dart';
import '../widgets/payment_summary_card.dart';
import '../widgets/record_payment_dialog.dart';
import '../widgets/record_vacation_dialog.dart';

/// Monthly detail screen - shows payment and vacation details for a specific month
class MonthlyDetailScreen extends ConsumerWidget {
  final int studentId;
  final int monthRecordId;

  const MonthlyDetailScreen({
    super.key,
    required this.studentId,
    required this.monthRecordId,
  });

  String _monthName(int month) {
    return DateFormat('MMMM').format(DateTime(2024, month));
  }

  Future<void> _recordPayment(
    BuildContext context,
    WidgetRef ref,
    double amountDue,
  ) async {
    final amount = await showRecordPaymentDialog(context, amountDue: amountDue);
    if (amount != null) {
      await ref
          .read(
            monthlyDetailNotifierProvider(studentId, monthRecordId).notifier,
          )
          .recordPayment(amount);
    }
  }

  Future<void> _recordVacation(
    BuildContext context,
    WidgetRef ref,
    int currentVacationDays,
  ) async {
    final days = await showRecordVacationDialog(
      context,
      currentVacationDays: currentVacationDays,
    );
    if (days != null) {
      await ref
          .read(
            monthlyDetailNotifierProvider(studentId, monthRecordId).notifier,
          )
          .recordVacation(days);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordAsync = ref.watch(
      monthlyDetailNotifierProvider(studentId, monthRecordId),
    );

    return recordAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Month Detail')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(title: const Text('Month Detail')),
        body: Center(child: Text('Failed to load record: $error')),
      ),
      data: (record) {
        if (record == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Month Detail')),
            body: const Center(child: Text('Record not found')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('${_monthName(record.month)} ${record.year}'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              PaymentSummaryCard(record: record),
              const SizedBox(height: 16),
              MonthlyActionsCard(
                record: record,
                onRecordPayment: () =>
                    _recordPayment(context, ref, record.amountDue),
                onRecordVacation: () =>
                    _recordVacation(context, ref, record.vacationDays),
              ),
            ],
          ),
        );
      },
    );
  }
}
