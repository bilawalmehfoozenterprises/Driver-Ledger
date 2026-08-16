import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/monthly_record.dart';
import '../../data/models/student.dart';
import '../../data/repositories/student_repository.dart';
import '../viewmodels/student_detail_notifier.dart';
import '../viewmodels/students_list_notifier.dart';
import '../widgets/deactivate_student_dialog.dart';
import '../widgets/monthly_records_list.dart';
import '../widgets/student_info_card.dart';

/// Student detail screen - shows monthly history
class StudentDetailScreen extends ConsumerWidget {
  final int studentId;

  const StudentDetailScreen({super.key, required this.studentId});

  Future<void> _deactivateStudent(
    BuildContext context,
    WidgetRef ref,
    Student student,
  ) async {
    final confirmed = await showDeactivateStudentDialog(
      context,
      studentName: student.name,
    );

    if (confirmed == true) {
      await ref.read(studentRepositoryProvider).deactivateStudent(studentId);
      ref.invalidate(studentsListNotifierProvider);
      if (context.mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(studentDetailNotifierProvider(studentId));

    return detailAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Student')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(title: const Text('Student')),
        body: Center(child: Text('Failed to load student: $error')),
      ),
      data: (state) {
        final student = state.student;
        if (student == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Student')),
            body: const Center(child: Text('Student not found')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(student.name),
            actions: [
              if (student.isActive)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    await context.push('/students/add', extra: student);
                    ref.invalidate(studentDetailNotifierProvider(studentId));
                  },
                ),
              if (student.isActive)
                IconButton(
                  icon: const Icon(Icons.person_off),
                  onPressed: () => _deactivateStudent(context, ref, student),
                ),
            ],
          ),
          body: Column(
            children: [
              StudentInfoCard(student: student),
              Expanded(
                child: MonthlyRecordsList(
                  records: state.records,
                  onRecordTap: (MonthlyRecord record) async {
                    await context.push(
                      '/students/$studentId/months/${record.id}',
                    );
                    ref.invalidate(studentDetailNotifierProvider(studentId));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
