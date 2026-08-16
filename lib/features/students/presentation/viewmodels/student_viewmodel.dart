import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:driver_ledger/core/enums/enums.dart';
import 'package:driver_ledger/features/students/data/models/student.dart';
import 'package:driver_ledger/features/students/data/repositories/student_repository.dart';

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return StudentRepository();
});

final studentsProvider = AsyncNotifierProvider<StudentsNotifier, List<Student>>(
  StudentsNotifier.new,
);

class StudentsNotifier extends AsyncNotifier<List<Student>> {
  @override
  Future<List<Student>> build() async {
    final repo = ref.read(studentRepositoryProvider);
    return repo.getAll();
  }

  Future<void> add({
    required String name,
    required String parentName,
    required String parentPhone,
    required double currentFee,
    required Shift shift,
  }) async {
    final repo = ref.read(studentRepositoryProvider);
    final student = Student(
      name: name,
      parentName: parentName,
      parentPhone: parentPhone,
      currentFee: currentFee,
      shift: shift,
      createdAt: DateTime.now(),
    );
    await repo.insert(student);
    ref.invalidateSelf();
  }

  Future<void> updateStudent(Student student) async {
    final repo = ref.read(studentRepositoryProvider);
    await repo.update(student);
    ref.invalidateSelf();
  }

  Future<void> deactivate(int id) async {
    final repo = ref.read(studentRepositoryProvider);
    await repo.deactivate(id);
    ref.invalidateSelf();
  }

  Future<void> activate(int id) async {
    final repo = ref.read(studentRepositoryProvider);
    await repo.activate(id);
    ref.invalidateSelf();
  }

  Future<void> delete(int id) async {
    final repo = ref.read(studentRepositoryProvider);
    await repo.delete(id);
    ref.invalidateSelf();
  }
}
