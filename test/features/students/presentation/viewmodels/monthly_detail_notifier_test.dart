import 'package:driver_ledger/features/students/data/models/monthly_record.dart';
import 'package:driver_ledger/features/students/data/repositories/monthly_record_repository.dart';
import 'package:driver_ledger/features/students/presentation/viewmodels/monthly_detail_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/fake_monthly_record_repository.dart';

MonthlyRecord _record({
  int id = 1,
  int studentId = 1,
  double expectedFee = 5000,
  double totalPaid = 0,
  int vacationDays = 0,
  double deductionAmount = 0,
}) {
  return MonthlyRecord(
    id: id,
    studentId: studentId,
    month: 1,
    year: 2024,
    expectedFee: expectedFee,
    totalPaid: totalPaid,
    vacationDays: vacationDays,
    deductionAmount: deductionAmount,
    createdAt: DateTime(2024, 1, 1),
  );
}

void main() {
  group('MonthlyDetailNotifier', () {
    test('fetches the record for the given studentId/monthRecordId', () async {
      final fakeRepository = FakeMonthlyRecordRepository(
        records: [_record(id: 10, studentId: 1)],
      );

      final container = ProviderContainer(
        overrides: [
          monthlyRecordRepositoryProvider.overrideWithValue(fakeRepository),
        ],
      );
      addTearDown(container.dispose);

      final record = await container.read(
        monthlyDetailNotifierProvider(1, 10).future,
      );

      expect(record?.id, 10);
    });

    test('recordPayment adds the amount to totalPaid and refreshes state', () async {
      final fakeRepository = FakeMonthlyRecordRepository(
        records: [_record(id: 10, totalPaid: 1000)],
      );

      final container = ProviderContainer(
        overrides: [
          monthlyRecordRepositoryProvider.overrideWithValue(fakeRepository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(monthlyDetailNotifierProvider(1, 10).future);
      await container
          .read(monthlyDetailNotifierProvider(1, 10).notifier)
          .recordPayment(2000);

      final record = container.read(monthlyDetailNotifierProvider(1, 10)).value;
      expect(record?.totalPaid, 3000);
    });

    test(
      'recordVacation applies dailyRate = expectedFee / 26, deduction = dailyRate * days',
      () async {
        final fakeRepository = FakeMonthlyRecordRepository(
          records: [_record(id: 10, expectedFee: 5200)],
        );

        final container = ProviderContainer(
          overrides: [
            monthlyRecordRepositoryProvider.overrideWithValue(fakeRepository),
          ],
        );
        addTearDown(container.dispose);

        await container.read(monthlyDetailNotifierProvider(1, 10).future);
        await container
            .read(monthlyDetailNotifierProvider(1, 10).notifier)
            .recordVacation(3);

        final record = container
            .read(monthlyDetailNotifierProvider(1, 10))
            .value;

        final expectedDeduction = (5200 / 26) * 3;
        expect(record?.vacationDays, 3);
        expect(record?.deductionAmount, expectedDeduction);
      },
    );

    test('calculateVacationDeduction is byte-identical to the original formula', () {
      expect(calculateVacationDeduction(5200, 3), (5200 / 26) * 3);
      expect(calculateVacationDeduction(0, 5), 0);
      expect(calculateVacationDeduction(2600, 0), 0);
    });

    test('editExpectedFee updates expectedFee and refreshes state', () async {
      final fakeRepository = FakeMonthlyRecordRepository(
        records: [_record(id: 10, expectedFee: 5000)],
      );

      final container = ProviderContainer(
        overrides: [
          monthlyRecordRepositoryProvider.overrideWithValue(fakeRepository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(monthlyDetailNotifierProvider(1, 10).future);
      await container
          .read(monthlyDetailNotifierProvider(1, 10).notifier)
          .editExpectedFee(6500);

      final record = container.read(monthlyDetailNotifierProvider(1, 10)).value;
      expect(record?.expectedFee, 6500);
    });
  });
}
