import 'package:driver_ledger/features/students/data/models/student.dart';
import 'package:driver_ledger/features/students/data/repositories/monthly_record_repository.dart';
import 'package:driver_ledger/features/students/data/repositories/student_repository.dart';
import 'package:driver_ledger/features/students/presentation/viewmodels/backfill_review_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/fake_monthly_record_repository.dart';
import '../../fakes/fake_student_repository.dart';

Student _student({
  required int id,
  double monthlyFee = 3000,
  required DateTime joinDate,
}) {
  return Student(
    id: id,
    name: 'Bilal',
    monthlyFee: monthlyFee,
    shift: .both,
    joinDate: joinDate,
    createdAt: joinDate,
  );
}

void main() {
  group('BackfillReviewNotifier', () {
    test(
      'lists one row per missing month, chronological, prefilled per rules',
      () async {
        // June 2024 has 30 days; joining on the 16th leaves 15 remaining days.
        final fakeStudentRepository = FakeStudentRepository(
          students: [_student(id: 1, joinDate: DateTime(2024, 6, 16))],
        );
        final fakeRecordRepository = FakeMonthlyRecordRepository();

        final container = ProviderContainer(
          overrides: [
            studentRepositoryProvider.overrideWithValue(fakeStudentRepository),
            monthlyRecordRepositoryProvider.overrideWithValue(
              fakeRecordRepository,
            ),
          ],
        );
        addTearDown(container.dispose);

        final state = await container.read(
          backfillReviewNotifierProvider(
            1,
          ).future,
        );

        final now = DateTime.now();
        final expectedRowCount = _monthsBetween(
          DateTime(2024, 6, 16),
          DateTime(now.year, now.month, 1),
        );
        expect(state.rows.length, expectedRowCount);

        final joinRow = state.rows.first;
        expect(joinRow.month, 6);
        expect(joinRow.year, 2024);
        expect(joinRow.expectedFee, (3000 / 30) * 15);
        expect(joinRow.amountPaid, joinRow.expectedFee);

        if (state.rows.length > 1) {
          final laterRow = state.rows[1];
          expect(laterRow.expectedFee, 3000);
        }

        // Rows are ordered chronologically.
        for (var i = 1; i < state.rows.length; i++) {
          final prev = state.rows[i - 1];
          final curr = state.rows[i];
          final prevKey = prev.year * 12 + prev.month;
          final currKey = curr.year * 12 + curr.month;
          expect(currKey, greaterThan(prevKey));
        }
      },
    );

    test('student with no gap returns an empty row list', () async {
      final now = DateTime.now();
      final fakeStudentRepository = FakeStudentRepository(
        students: [_student(id: 1, joinDate: DateTime(now.year, now.month, 1))],
      );
      final fakeRecordRepository = FakeMonthlyRecordRepository();

      final container = ProviderContainer(
        overrides: [
          studentRepositoryProvider.overrideWithValue(fakeStudentRepository),
          monthlyRecordRepositoryProvider.overrideWithValue(
            fakeRecordRepository,
          ),
        ],
      );
      addTearDown(container.dispose);

      final state = await container.read(
        backfillReviewNotifierProvider(1).future,
      );

      expect(state.rows, isEmpty);
    });

    test('updateExpectedFee edits a single row without touching others', () async {
      final fakeStudentRepository = FakeStudentRepository(
        students: [_student(id: 1, joinDate: DateTime(2024, 3, 1))],
      );
      final fakeRecordRepository = FakeMonthlyRecordRepository();

      final container = ProviderContainer(
        overrides: [
          studentRepositoryProvider.overrideWithValue(fakeStudentRepository),
          monthlyRecordRepositoryProvider.overrideWithValue(
            fakeRecordRepository,
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(backfillReviewNotifierProvider(1).future);
      final notifier = container.read(
        backfillReviewNotifierProvider(1).notifier,
      );

      notifier.updateExpectedFee(0, 1500);

      final state = container.read(backfillReviewNotifierProvider(1)).value!;
      expect(state.rows[0].expectedFee, 1500);
      if (state.rows.length > 1) {
        expect(state.rows[1].expectedFee, 3000);
      }
    });

    test(
      'updateAmountPaid changes row status live (Unpaid/Partial/Paid)',
      () async {
        final fakeStudentRepository = FakeStudentRepository(
          students: [_student(id: 1, joinDate: DateTime(2024, 3, 1))],
        );
        final fakeRecordRepository = FakeMonthlyRecordRepository();

        final container = ProviderContainer(
          overrides: [
            studentRepositoryProvider.overrideWithValue(fakeStudentRepository),
            monthlyRecordRepositoryProvider.overrideWithValue(
              fakeRecordRepository,
            ),
          ],
        );
        addTearDown(container.dispose);

        await container.read(backfillReviewNotifierProvider(1).future);
        final notifier = container.read(
          backfillReviewNotifierProvider(1).notifier,
        );

        notifier.updateAmountPaid(0, 0);
        var state = container.read(backfillReviewNotifierProvider(1)).value!;
        expect(state.rows[0].status, 'Unpaid');

        notifier.updateAmountPaid(0, 1000);
        state = container.read(backfillReviewNotifierProvider(1)).value!;
        expect(state.rows[0].status, 'Partial');

        notifier.updateAmountPaid(0, 3000);
        state = container.read(backfillReviewNotifierProvider(1)).value!;
        expect(state.rows[0].status, 'Paid');
      },
    );

    test('save persists exactly the rows final edited values as new records', () async {
      final fakeStudentRepository = FakeStudentRepository(
        students: [_student(id: 1, joinDate: DateTime(2024, 3, 1))],
      );
      final fakeRecordRepository = FakeMonthlyRecordRepository();

      final container = ProviderContainer(
        overrides: [
          studentRepositoryProvider.overrideWithValue(fakeStudentRepository),
          monthlyRecordRepositoryProvider.overrideWithValue(
            fakeRecordRepository,
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(backfillReviewNotifierProvider(1).future);
      final notifier = container.read(
        backfillReviewNotifierProvider(1).notifier,
      );

      notifier.updateExpectedFee(0, 2000);
      notifier.updateAmountPaid(0, 500);

      await notifier.save();

      final saved = await fakeRecordRepository.getRecordsForStudent(1);
      final firstSaved = saved.firstWhere(
        (r) => r.month == 3 && r.year == 2024,
      );
      expect(firstSaved.expectedFee, 2000);
      expect(firstSaved.totalPaid, 500);
    });

    test('backing out without saving creates no records', () async {
      final fakeStudentRepository = FakeStudentRepository(
        students: [_student(id: 1, joinDate: DateTime(2024, 3, 1))],
      );
      final fakeRecordRepository = FakeMonthlyRecordRepository();

      final container = ProviderContainer(
        overrides: [
          studentRepositoryProvider.overrideWithValue(fakeStudentRepository),
          monthlyRecordRepositoryProvider.overrideWithValue(
            fakeRecordRepository,
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(backfillReviewNotifierProvider(1).future);
      final notifier = container.read(
        backfillReviewNotifierProvider(1).notifier,
      );
      notifier.updateExpectedFee(0, 9999);

      // Simulate "backing out": container is disposed without calling save().
      final saved = await fakeRecordRepository.getRecordsForStudent(1);
      expect(saved, isEmpty);
    });

    test(
      'skip creates each missing month as Unpaid using the prefill rule, ignoring row edits',
      () async {
        // June 2024 has 30 days; joining on the 16th leaves 15 remaining days.
        final fakeStudentRepository = FakeStudentRepository(
          students: [_student(id: 1, joinDate: DateTime(2024, 6, 16))],
        );
        final fakeRecordRepository = FakeMonthlyRecordRepository();

        final container = ProviderContainer(
          overrides: [
            studentRepositoryProvider.overrideWithValue(fakeStudentRepository),
            monthlyRecordRepositoryProvider.overrideWithValue(
              fakeRecordRepository,
            ),
          ],
        );
        addTearDown(container.dispose);

        await container.read(backfillReviewNotifierProvider(1).future);
        final notifier = container.read(
          backfillReviewNotifierProvider(1).notifier,
        );

        // Edits made before skipping must be ignored by skip's fallback.
        notifier.updateAmountPaid(0, 9999);

        await notifier.skip();

        final saved = await fakeRecordRepository.getRecordsForStudent(1);
        final joinMonthRecord = saved.firstWhere(
          (r) => r.month == 6 && r.year == 2024,
        );
        expect(joinMonthRecord.expectedFee, (3000 / 30) * 15);
        expect(joinMonthRecord.totalPaid, 0);
        expect(joinMonthRecord.status, 'Unpaid');

        for (final record in saved) {
          expect(record.totalPaid, 0);
        }
      },
    );
  });
}

int _monthsBetween(DateTime joinDate, DateTime beforeMonth) {
  var month = joinDate.month;
  var year = joinDate.year;
  var count = 0;
  while (year < beforeMonth.year ||
      (year == beforeMonth.year && month < beforeMonth.month)) {
    count++;
    if (month == 12) {
      month = 1;
      year++;
    } else {
      month++;
    }
  }
  return count;
}
