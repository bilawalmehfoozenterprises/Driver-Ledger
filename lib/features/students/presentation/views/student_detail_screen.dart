import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../data/models/monthly_record.dart';
import '../../data/models/student.dart';
import '../../data/repositories/student_repository.dart';
import '../viewmodels/student_detail_notifier.dart';
import '../viewmodels/students_list_notifier.dart';
import '../widgets/deactivate_student_dialog.dart';
import '../widgets/monthly_records_list.dart';
import '../widgets/student_header_band.dart';
import '../widgets/student_info_grid.dart';

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

        final currentRecord = state.records.isEmpty
            ? null
            : state.records.first;
        final colors = studentBandColors(
          Theme.of(context).colorScheme,
          currentRecord,
        );

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 160,
                backgroundColor: colors.band,
                foregroundColor: colors.onBand,
                iconTheme: IconThemeData(color: colors.onBand),
                actions: [
                  if (student.isActive)
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        await context.pushNamed(
                          AppRoutes.editStudent.name,
                          pathParameters: {'id': studentId.toString()},
                        );
                        ref.invalidate(
                          studentDetailNotifierProvider(studentId),
                        );
                      },
                    ),
                  if (student.isActive)
                    IconButton(
                      icon: const Icon(Icons.person_off),
                      onPressed: () =>
                          _deactivateStudent(context, ref, student),
                    ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: StudentHeaderBand(
                    student: student,
                    currentRecord: currentRecord,
                  ),
                ),
              ),
              SliverToBoxAdapter(child: StudentInfoGrid(student: student)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Text(
                    'MONTHS',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              if (state.records.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    child: Text('No monthly records yet'),
                  ),
                )
              else
                SliverToBoxAdapter(
                  child: MonthlyRecordsList(
                    records: state.records,
                    onRecordTap: (MonthlyRecord record) async {
                      await context.pushNamed(
                        AppRoutes.monthlyDetail.name,
                        pathParameters: {
                          'studentId': studentId.toString(),
                          'monthId': record.id.toString(),
                        },
                      );
                      ref.invalidate(
                        studentDetailNotifierProvider(studentId),
                      );
                    },
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        );
      },
    );
  }
}
