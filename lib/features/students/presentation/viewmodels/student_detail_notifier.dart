import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/monthly_record.dart';
import '../../data/models/student.dart';
import '../../data/repositories/monthly_record_repository.dart';
import '../../data/repositories/student_repository.dart';

part 'student_detail_notifier.g.dart';

class StudentDetailState {
  final Student? student;
  final List<MonthlyRecord> records;

  const StudentDetailState({required this.student, required this.records});
}

@riverpod
class StudentDetailNotifier extends _$StudentDetailNotifier {
  @override
  Future<StudentDetailState> build(int studentId) async {
    final studentRepository = ref.watch(studentRepositoryProvider);
    final monthlyRecordRepository = ref.watch(monthlyRecordRepositoryProvider);

    final student = await studentRepository.getStudent(studentId);

    // Ensure current month record exists
    final now = DateTime.now();
    await monthlyRecordRepository.getOrCreateRecord(
      studentId,
      now.month,
      now.year,
      student?.monthlyFee ?? 0,
    );

    // Reload records after potential creation
    final records = await monthlyRecordRepository.getRecordsForStudent(
      studentId,
    );

    return StudentDetailState(student: student, records: records);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
