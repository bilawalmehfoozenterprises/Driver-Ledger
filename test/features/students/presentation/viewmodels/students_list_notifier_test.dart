import 'package:driver_ledger/features/students/data/models/student.dart';
import 'package:driver_ledger/features/students/data/repositories/student_repository.dart';
import 'package:driver_ledger/features/students/presentation/viewmodels/students_list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/fake_student_repository.dart';

Student _student({
  required int id,
  required String name,
  bool isActive = true,
}) {
  return Student(
    id: id,
    name: name,
    monthlyFee: 5000,
    shift: .both,
    joinDate: DateTime(2024, 1, 1),
    isActive: isActive,
    createdAt: DateTime(2024, 1, 1),
  );
}

void main() {
  group('StudentsListNotifier', () {
    test('splits students into active and inactive sections', () async {
      final fakeRepository = FakeStudentRepository(
        students: [
          _student(id: 1, name: 'Bilal', isActive: true),
          _student(id: 2, name: 'Ahmed', isActive: false),
          _student(id: 3, name: 'Zara', isActive: true),
        ],
      );

      final container = ProviderContainer(
        overrides: [
          studentRepositoryProvider.overrideWithValue(fakeRepository),
        ],
      );
      addTearDown(container.dispose);

      final state = await container.read(
        studentsListNotifierProvider.future,
      );

      expect(state.activeStudents.map((s) => s.name), ['Bilal', 'Zara']);
      expect(state.inactiveStudents.map((s) => s.name), ['Ahmed']);
    });

    test('returns empty sections when there are no students', () async {
      final container = ProviderContainer(
        overrides: [
          studentRepositoryProvider.overrideWithValue(
            FakeStudentRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final state = await container.read(
        studentsListNotifierProvider.future,
      );

      expect(state.activeStudents, isEmpty);
      expect(state.inactiveStudents, isEmpty);
    });
  });
}
