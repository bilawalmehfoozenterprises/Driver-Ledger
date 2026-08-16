import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/monthly_record.dart';
import '../../data/repositories/monthly_record_repository.dart';
import '../../data/repositories/student_repository.dart';
import '../../domain/backfill_calculator.dart';

part 'backfill_review_notifier.g.dart';

class BackfillReviewRow {
  final int month;
  final int year;
  final double expectedFee;
  final double amountPaid;

  const BackfillReviewRow({
    required this.month,
    required this.year,
    required this.expectedFee,
    required this.amountPaid,
  });

  double get balance => expectedFee - amountPaid;

  bool get isFullyPaid => balance <= 0;

  String get status {
    if (isFullyPaid) return 'Paid';
    if (amountPaid > 0) return 'Partial';
    return 'Unpaid';
  }

  BackfillReviewRow copyWith({double? expectedFee, double? amountPaid}) {
    return BackfillReviewRow(
      month: month,
      year: year,
      expectedFee: expectedFee ?? this.expectedFee,
      amountPaid: amountPaid ?? this.amountPaid,
    );
  }
}

class BackfillReviewState {
  final int studentId;
  final List<BackfillReviewRow> rows;

  const BackfillReviewState({required this.studentId, required this.rows});
}

@riverpod
class BackfillReviewNotifier extends _$BackfillReviewNotifier {
  @override
  Future<BackfillReviewState> build(int studentId) async {
    final studentRepository = ref.watch(studentRepositoryProvider);
    final recordRepository = ref.watch(monthlyRecordRepositoryProvider);

    final student = await studentRepository.getStudent(studentId);
    if (student == null) {
      return BackfillReviewState(studentId: studentId, rows: const []);
    }

    final existingRecords = await recordRepository.getRecordsForStudent(
      studentId,
    );
    final missingMonths = calculateMissingMonths(
      joinDate: student.joinDate,
      now: DateTime.now(),
      existingRecords: existingRecords,
    );

    final rows = missingMonths.map((missingMonth) {
      final isJoinMonth =
          missingMonth.month == student.joinDate.month &&
          missingMonth.year == student.joinDate.year;

      final expectedFee = isJoinMonth
          ? calculateProratedFee(
              monthlyFee: student.monthlyFee,
              month: missingMonth.month,
              year: missingMonth.year,
              joinDate: student.joinDate,
            )
          : student.monthlyFee;

      return BackfillReviewRow(
        month: missingMonth.month,
        year: missingMonth.year,
        expectedFee: expectedFee,
        amountPaid: expectedFee,
      );
    }).toList();

    return BackfillReviewState(studentId: studentId, rows: rows);
  }

  void updateExpectedFee(int index, double expectedFee) {
    final current = state.valueOrNull;
    if (current == null) return;

    final rows = [...current.rows];
    rows[index] = rows[index].copyWith(expectedFee: expectedFee);
    state = AsyncData(
      BackfillReviewState(studentId: current.studentId, rows: rows),
    );
  }

  void updateAmountPaid(int index, double amountPaid) {
    final current = state.valueOrNull;
    if (current == null) return;

    final rows = [...current.rows];
    rows[index] = rows[index].copyWith(amountPaid: amountPaid);
    state = AsyncData(
      BackfillReviewState(studentId: current.studentId, rows: rows),
    );
  }

  Future<void> save() async {
    final current = state.valueOrNull;
    if (current == null || current.rows.isEmpty) return;

    final repository = ref.read(monthlyRecordRepositoryProvider);
    final now = DateTime.now();
    final records = current.rows
        .map(
          (row) => MonthlyRecord(
            studentId: current.studentId,
            month: row.month,
            year: row.year,
            expectedFee: row.expectedFee,
            totalPaid: row.amountPaid,
            createdAt: now,
          ),
        )
        .toList();

    await repository.insertRecords(records);
  }
}
