import 'package:driver_ledger/core/enums/enums.dart';
import 'package:driver_ledger/features/students/data/models/monthly_record.dart';
import 'package:driver_ledger/features/students/data/models/student.dart';
import 'package:driver_ledger/features/students/data/repositories/monthly_record_repository.dart';
import 'package:driver_ledger/features/students/data/repositories/student_repository.dart';
import 'package:driver_ledger/features/students/presentation/viewmodels/student_detail_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/fake_monthly_record_repository.dart';
import '../../fakes/fake_student_repository.dart';

Student _student({required int id, double monthlyFee = 5000}) {
  return Student(
    id: id,
    name: 'Bilal',
    monthlyFee: monthlyFee,
    shift: Shift.both,
    joinDate: DateTime(2024, 1, 1),
    createdAt: DateTime(2024, 1, 1),
  );
}

void main() {
  group('StudentDetailNotifier', () {
    test('loads student and its monthly records', () async {
      final now = DateTime.now();
      final fakeStudentRepository = FakeStudentRepository(
        students: [_student(id: 1)],
      );
      final fakeRecordRepository = FakeMonthlyRecordRepository(
        records: [
          MonthlyRecord(
            id: 10,
            studentId: 1,
            month: now.month,
            year: now.year,
            expectedFee: 5000,
            createdAt: now,
          ),
        ],
      );

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
        studentDetailNotifierProvider(1).future,
      );

      expect(state.student?.id, 1);
      expect(state.records, hasLength(1));
      expect(state.records.first.id, 10);
    });

    test(
      'creates the current month record when it does not exist yet',
      () async {
        final fakeStudentRepository = FakeStudentRepository(
          students: [_student(id: 1, monthlyFee: 7000)],
        );
        final fakeRecordRepository = FakeMonthlyRecordRepository();

        final container = ProviderContainer(
          overrides: [
            studentRepositoryProvider.overrideWithValue(
              fakeStudentRepository,
            ),
            monthlyRecordRepositoryProvider.overrideWithValue(
              fakeRecordRepository,
            ),
          ],
        );
        addTearDown(container.dispose);

        final state = await container.read(
          studentDetailNotifierProvider(1).future,
        );

        final now = DateTime.now();
        expect(state.records, hasLength(1));
        expect(state.records.first.month, now.month);
        expect(state.records.first.year, now.year);
        expect(state.records.first.expectedFee, 7000);
      },
    );
  });
}
