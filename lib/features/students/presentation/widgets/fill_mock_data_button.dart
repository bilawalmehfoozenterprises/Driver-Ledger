import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/add_student_form_notifier.dart';

/// Dev convenience button that fills the add/edit form with fake data.
class FillMockDataButton extends ConsumerWidget {
  final int? studentId;
  final VoidCallback onFilled;

  const FillMockDataButton({
    super.key,
    required this.studentId,
    required this.onFilled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        ref
            .read(addStudentFormNotifierProvider(studentId).notifier)
            .fillMockData();
        onFilled();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mock student details filled')),
        );
      },
      tooltip: 'Fill mock data',
      icon: const Icon(Icons.auto_awesome),
    );
  }
}
