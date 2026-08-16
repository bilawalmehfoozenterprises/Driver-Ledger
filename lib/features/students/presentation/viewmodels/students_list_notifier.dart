import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/student.dart';
import '../../data/repositories/student_repository.dart';

part 'students_list_notifier.g.dart';

class StudentsListState {
  final List<Student> activeStudents;
  final List<Student> inactiveStudents;

  const StudentsListState({
    required this.activeStudents,
    required this.inactiveStudents,
  });
}

@riverpod
class StudentsListNotifier extends _$StudentsListNotifier {
  @override
  Future<StudentsListState> build() async {
    final repository = ref.watch(studentRepositoryProvider);
    final allStudents = await repository.getAllStudents();
    return StudentsListState(
      activeStudents: allStudents.where((s) => s.isActive).toList(),
      inactiveStudents: allStudents.where((s) => !s.isActive).toList(),
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
