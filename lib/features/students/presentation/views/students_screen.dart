import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/student.dart';
import '../viewmodels/students_list_notifier.dart';
import '../widgets/student_list_section.dart';
import '../widgets/students_empty_state.dart';

/// Students screen - List of all students
class StudentsScreen extends ConsumerWidget {
  const StudentsScreen({super.key});

  Future<void> _openStudent(BuildContext context, WidgetRef ref, int id) async {
    await context.push('/students/$id');
    ref.invalidate(studentsListNotifierProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsync = ref.watch(studentsListNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Students')),
      body: studentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Failed to load students: $error')),
        data: (state) {
          if (state.activeStudents.isEmpty && state.inactiveStudents.isEmpty) {
            return const StudentsEmptyState();
          }
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(studentsListNotifierProvider.notifier).refresh(),
            child: ListView(
              children: [
                StudentListSection(
                  title: 'Active Students',
                  students: state.activeStudents,
                  onStudentTap: (Student student) =>
                      _openStudent(context, ref, student.id!),
                ),
                StudentListSection(
                  title: 'Inactive Students',
                  students: state.inactiveStudents,
                  isInactive: true,
                  onStudentTap: (Student student) =>
                      _openStudent(context, ref, student.id!),
                ),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/students/add');
          ref.invalidate(studentsListNotifierProvider);
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Add Student'),
      ),
    );
  }
}
