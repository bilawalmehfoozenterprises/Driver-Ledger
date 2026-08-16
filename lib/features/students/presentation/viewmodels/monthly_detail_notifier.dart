import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/monthly_record.dart';
import '../../data/repositories/monthly_record_repository.dart';

part 'monthly_detail_notifier.g.dart';

/// Working days per month used to prorate the vacation deduction.
const _workingDaysPerMonth = 26;

double calculateVacationDeduction(double expectedFee, int vacationDays) {
  final dailyRate = expectedFee / _workingDaysPerMonth;
  return dailyRate * vacationDays;
}

@riverpod
class MonthlyDetailNotifier extends _$MonthlyDetailNotifier {
  @override
  Future<MonthlyRecord?> build(int studentId, int monthRecordId) async {
    final repository = ref.watch(monthlyRecordRepositoryProvider);
    final records = await repository.getRecordsForStudent(studentId);
    if (records.isEmpty) return null;
    return records.firstWhere(
      (r) => r.id == monthRecordId,
      orElse: () => records.first,
    );
  }

  Future<void> recordPayment(double amount) async {
    final repository = ref.read(monthlyRecordRepositoryProvider);
    await repository.recordPayment(monthRecordId, amount);
    ref.invalidateSelf();
    await future;
  }

  Future<void> recordVacation(int vacationDays) async {
    final record = state.valueOrNull;
    if (record == null) return;

    final deduction = calculateVacationDeduction(
      record.expectedFee,
      vacationDays,
    );

    final repository = ref.read(monthlyRecordRepositoryProvider);
    await repository.recordVacation(monthRecordId, vacationDays, deduction);
    ref.invalidateSelf();
    await future;
  }
}
