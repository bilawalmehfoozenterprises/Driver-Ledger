import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../data/models/student.dart';
import '../viewmodels/students_list_notifier.dart';
import '../widgets/student_tab_list.dart';
import '../widgets/students_empty_state.dart';

/// Students screen - List of all students, split into Active/Inactive tabs
class StudentsScreen extends ConsumerWidget {
  const StudentsScreen({super.key});

  Future<void> _openStudent(BuildContext context, WidgetRef ref, int id) async {
    await context.pushNamed(
      AppRoutes.studentDetail.name,
      pathParameters: {'id': id.toString()},
    );
    ref.invalidate(studentsListNotifierProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsync = ref.watch(studentsListNotifierProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Students'),
          bottom: const TabBar(
            tabs: [Tab(text: 'Active'), Tab(text: 'Inactive')],
          ),
        ),
        body: studentsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('Failed to load students: $error')),
          data: (state) {
            Future<void> refresh() =>
                ref.read(studentsListNotifierProvider.notifier).refresh();

            return TabBarView(
              children: [
                StudentTabList(
                  students: state.activeStudents,
                  onStudentTap: (Student student) =>
                      _openStudent(context, ref, student.id!),
                  onRefresh: refresh,
                  emptyState: const StudentsEmptyState(),
                ),
                StudentTabList(
                  students: state.inactiveStudents,
                  isInactive: true,
                  onStudentTap: (Student student) =>
                      _openStudent(context, ref, student.id!),
                  onRefresh: refresh,
                  emptyState: const StudentsEmptyState(
                    title: 'No Inactive Students',
                    message: 'Students you deactivate will show up here.',
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await context.pushNamed(AppRoutes.addStudent.name);
            ref.invalidate(studentsListNotifierProvider);
          },
          icon: const Icon(Icons.person_add),
          label: const Text('Add Student'),
        ),
      ),
    );
  }
}
