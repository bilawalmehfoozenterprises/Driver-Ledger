import 'package:flutter/material.dart';

import '../../data/models/student.dart';
import 'student_card.dart';

/// Scrollable list of student cards for a single Active/Inactive tab.
class StudentTabList extends StatelessWidget {
  final List<Student> students;
  final bool isInactive;
  final void Function(Student student) onStudentTap;
  final Widget emptyState;
  final Future<void> Function() onRefresh;

  const StudentTabList({
    super.key,
    required this.students,
    required this.onStudentTap,
    required this.emptyState,
    required this.onRefresh,
    this.isInactive = false,
  });

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) return emptyState;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        children: [
          const SizedBox(height: 8),
          for (final student in students)
            StudentCard(
              student: student,
              isInactive: isInactive,
              onTap: () => onStudentTap(student),
            ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
