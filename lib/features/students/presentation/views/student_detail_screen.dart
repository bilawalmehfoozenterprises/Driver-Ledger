import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../data/models/monthly_record.dart';
import '../../data/models/student.dart';
import '../../data/repositories/monthly_record_repository.dart';
import '../../data/repositories/student_repository.dart';
import '../../domain/backfill_calculator.dart';
import '../viewmodels/monthly_detail_notifier.dart';
import '../viewmodels/student_detail_notifier.dart';
import '../viewmodels/students_list_notifier.dart';
import '../widgets/deactivate_student_dialog.dart';
import '../widgets/record_payment_dialog.dart';
import '../widgets/record_vacation_dialog.dart';
import '../widgets/student_info_grid.dart';
import '../widgets/this_month_card.dart';

/// Student detail screen - shows this month's status, student info, and history
class StudentDetailScreen extends ConsumerWidget {
  final int studentId;

  const StudentDetailScreen({super.key, required this.studentId});

  Future<void> _deactivateStudent(
    BuildContext context,
    WidgetRef ref,
    Student student,
  ) async {
    final confirmed = await showDeactivateStudentDialog(
      context,
      studentName: student.name,
    );

    if (confirmed == true) {
      await ref.read(studentRepositoryProvider).deactivateStudent(studentId);
      ref.invalidate(studentsListNotifierProvider);
      if (context.mounted) {
        context.pop();
      }
    }
  }

  Future<void> _recordPayment(
    BuildContext context,
    WidgetRef ref,
    MonthlyRecord record,
  ) async {
    final amount = await showRecordPaymentDialog(
      context,
      amountDue: record.amountDue,
    );
    if (amount == null) return;

    await ref
        .read(monthlyRecordRepositoryProvider)
        .recordPayment(record.id!, amount);
    ref.invalidate(studentDetailNotifierProvider(studentId));
  }

  Future<void> _recordVacation(
    BuildContext context,
    WidgetRef ref,
    MonthlyRecord record,
  ) async {
    final days = await showRecordVacationDialog(
      context,
      currentVacationDays: record.vacationDays,
    );
    if (days == null) return;

    final deduction = calculateVacationDeduction(record.expectedFee, days);
    await ref
        .read(monthlyRecordRepositoryProvider)
        .recordVacation(record.id!, days, deduction);
    ref.invalidate(studentDetailNotifierProvider(studentId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(studentDetailNotifierProvider(studentId));

    return detailAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Student')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(title: const Text('Student')),
        body: Center(child: Text('Failed to load student: $error')),
      ),
      data: (state) {
        final student = state.student;
        if (student == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Student')),
            body: const Center(child: Text('Student not found')),
          );
        }

        final currentRecord = state.records.isEmpty
            ? null
            : state.records.first;

        final hasMissingMonths = calculateMissingMonths(
          joinDate: student.joinDate,
          now: DateTime.now(),
          existingRecords: state.records,
        ).isNotEmpty;

        return Scaffold(
          appBar: AppBar(
            title: Text(student.name),
            actions: [
              if (hasMissingMonths)
                IconButton(
                  icon: const Icon(Icons.history),
                  tooltip: 'Backfill history',
                  onPressed: () {
                    context.pushNamed(
                      AppRoutes.backfillReview.name,
                      pathParameters: {'studentId': studentId.toString()},
                    );
                  },
                ),
              if (student.isActive)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    await context.pushNamed(
                      AppRoutes.editStudent.name,
                      pathParameters: {'id': studentId.toString()},
                    );
                    ref.invalidate(studentDetailNotifierProvider(studentId));
                  },
                ),
              if (student.isActive)
                IconButton(
                  icon: const Icon(Icons.person_off),
                  onPressed: () => _deactivateStudent(context, ref, student),
                ),
            ],
          ),
          body: ListView(
            children: [
              StudentInfoGrid(student: student),
              if (currentRecord != null)
                ThisMonthCard(
                  record: currentRecord,
                  onRecordPayment: () =>
                      _recordPayment(context, ref, currentRecord),
                  onRecordVacation: () =>
                      _recordVacation(context, ref, currentRecord),
                  onViewHistory: () {
                    context.pushNamed(
                      AppRoutes.paymentHistory.name,
                      pathParameters: {'id': studentId.toString()},
                    );
                  },
                ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
