import 'dart:async';

import 'package:driver_ledger/core/enums/enums.dart';
import 'package:driver_ledger/features/students/data/models/student.dart';
import 'package:driver_ledger/features/students/data/repositories/student_repository.dart';
import 'package:driver_ledger/features/students/presentation/viewmodels/add_student_form_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/fake_student_repository.dart';

/// Waits until the edit-mode async load (triggered from `build()`) settles.
Future<AddStudentFormState> _waitForLoad(
  ProviderContainer container,
  int studentId,
) async {
  final provider = addStudentFormNotifierProvider(studentId);
  final initial = container.read(provider);
  if (!initial.isLoading) return initial;

  final completer = Completer<AddStudentFormState>();
  late final ProviderSubscription<AddStudentFormState> subscription;
  subscription = container.listen(provider, (previous, next) {
    if (!next.isLoading) {
      completer.complete(next);
      subscription.close();
    }
  });
  return completer.future;
}

Student _student({required int id}) {
  return Student(
    id: id,
    name: 'Bilal',
    parentName: 'Ahmed',
    parentPhone: '03001234567',
    monthlyFee: 5000,
    shift: Shift.morning,
    pickupLocation: 'Gulshan',
    dropoffLocation: 'DHA',
    joinDate: DateTime(2024, 3, 1),
    createdAt: DateTime(2024, 3, 1),
  );
}

void main() {
  group('AddStudentFormNotifier', () {
    test('create mode starts with blank fields', () {
      final container = ProviderContainer(
        overrides: [
          studentRepositoryProvider.overrideWithValue(
            FakeStudentRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final state = container.read(addStudentFormNotifierProvider(null));

      expect(state.isEditing, isFalse);
      expect(state.isLoading, isFalse);
      expect(state.name, isEmpty);
      expect(state.shift, Shift.both);
    });

    test('edit mode initializes fields from the existing student', () async {
      final fakeRepository = FakeStudentRepository(
        students: [_student(id: 1)],
      );
      final container = ProviderContainer(
        overrides: [
          studentRepositoryProvider.overrideWithValue(fakeRepository),
        ],
      );
      addTearDown(container.dispose);

      final state = await _waitForLoad(container, 1);

      expect(state.isEditing, isTrue);
      expect(state.isLoading, isFalse);
      expect(state.name, 'Bilal');
      expect(state.parentName, 'Ahmed');
      expect(state.parentPhone, '03001234567');
      expect(state.monthlyFee, '5000');
      expect(state.shift, Shift.morning);
      expect(state.pickupLocation, 'Gulshan');
      expect(state.dropoffLocation, 'DHA');
    });

    test('fillMockData populates all fields with non-empty fake values', () {
      final container = ProviderContainer(
        overrides: [
          studentRepositoryProvider.overrideWithValue(
            FakeStudentRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(
        addStudentFormNotifierProvider(null).notifier,
      );
      notifier.fillMockData();

      final state = container.read(addStudentFormNotifierProvider(null));
      expect(state.name, isNotEmpty);
      expect(state.parentName, isNotEmpty);
      expect(state.parentPhone, isNotEmpty);
      expect(state.monthlyFee, isNotEmpty);
    });

    test('save() in create mode inserts a new student', () async {
      final fakeRepository = FakeStudentRepository();
      final container = ProviderContainer(
        overrides: [
          studentRepositoryProvider.overrideWithValue(fakeRepository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(
        addStudentFormNotifierProvider(null).notifier,
      );
      notifier
        ..updateName('New Student')
        ..updateMonthlyFee('4500');

      await notifier.save();

      expect(fakeRepository.students, hasLength(1));
      expect(fakeRepository.students.first.name, 'New Student');
      expect(fakeRepository.students.first.monthlyFee, 4500);
      final state = container.read(addStudentFormNotifierProvider(null));
      expect(state.isSaving, isFalse);
    });

    test('save() in edit mode updates the existing student', () async {
      final fakeRepository = FakeStudentRepository(
        students: [_student(id: 1)],
      );
      final container = ProviderContainer(
        overrides: [
          studentRepositoryProvider.overrideWithValue(fakeRepository),
        ],
      );
      addTearDown(container.dispose);

      await _waitForLoad(container, 1);

      final notifier = container.read(
        addStudentFormNotifierProvider(1).notifier,
      );
      notifier.updateName('Updated Name');

      await notifier.save();

      expect(fakeRepository.students, hasLength(1));
      expect(fakeRepository.students.first.id, 1);
      expect(fakeRepository.students.first.name, 'Updated Name');
    });

    test('save() surfaces repository failures without crashing state', () async {
      final container = ProviderContainer(
        overrides: [
          studentRepositoryProvider.overrideWithValue(
            _ThrowingStudentRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(
        addStudentFormNotifierProvider(null).notifier,
      );
      notifier
        ..updateName('New Student')
        ..updateMonthlyFee('4500');

      await expectLater(notifier.save(), throwsException);
    });
  });
}

class _ThrowingStudentRepository implements StudentRepository {
  @override
  Future<void> deactivateStudent(int id) => throw UnimplementedError();

  @override
  Future<List<Student>> getActiveStudents() => throw UnimplementedError();

  @override
  Future<List<Student>> getAllStudents() => throw UnimplementedError();

  @override
  Future<Student?> getStudent(int id) async => null;

  @override
  Future<int> insertStudent(Student student) async {
    throw Exception('insert failed');
  }

  @override
  Future<void> updateStudent(Student student) => throw UnimplementedError();
}
