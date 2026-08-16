import 'package:flutter/material.dart';

import '../../data/models/student.dart';
import 'student_card.dart';

/// A titled section of student cards (e.g. "Active Students").
class StudentListSection extends StatelessWidget {
  final String title;
  final List<Student> students;
  final bool isInactive;
  final void Function(Student student) onStudentTap;

  const StudentListSection({
    super.key,
    required this.title,
    required this.students,
    required this.onStudentTap,
    this.isInactive = false,
  });

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: .start,
      children: [
        Padding(
          padding: .fromLTRB(16, isInactive ? 24 : 16, 16, 8),
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        ...students.map(
          (student) => StudentCard(
            student: student,
            isInactive: isInactive,
            onTap: () => onStudentTap(student),
          ),
        ),
      ],
    );
  }
}
