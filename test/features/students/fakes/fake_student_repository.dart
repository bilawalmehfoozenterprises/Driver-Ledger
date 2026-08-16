import 'package:driver_ledger/features/students/data/models/student.dart';
import 'package:driver_ledger/features/students/data/repositories/student_repository.dart';

/// In-memory fake of [StudentRepository] for use in provider overrides.
class FakeStudentRepository implements StudentRepository {
  final List<Student> students;
  int _nextId;

  FakeStudentRepository({List<Student>? students})
    : students = students ?? [],
      _nextId = (students?.map((s) => s.id ?? 0).fold(0, (a, b) => a > b ? a : b) ?? 0) + 1;

  @override
  Future<List<Student>> getAllStudents() async {
    final sorted = List<Student>.of(students)
      ..sort((a, b) => a.name.compareTo(b.name));
    return sorted;
  }

  @override
  Future<List<Student>> getActiveStudents() async {
    return students.where((s) => s.isActive).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Future<Student?> getStudent(int id) async {
    try {
      return students.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<int> insertStudent(Student student) async {
    final id = _nextId++;
    students.add(student.copyWith(id: id));
    return id;
  }

  @override
  Future<void> updateStudent(Student student) async {
    final index = students.indexWhere((s) => s.id == student.id);
    if (index != -1) {
      students[index] = student;
    }
  }

  @override
  Future<void> deactivateStudent(int id) async {
    final index = students.indexWhere((s) => s.id == id);
    if (index != -1) {
      students[index] = students[index].copyWith(isActive: false);
    }
  }
}
