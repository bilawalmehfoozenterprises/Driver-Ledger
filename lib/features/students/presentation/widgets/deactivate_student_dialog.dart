import 'package:flutter/material.dart';

/// Confirmation dialog for deactivating a student.
/// Returns `true` via [showDialog] if the user confirms.
Future<bool?> showDeactivateStudentDialog(
  BuildContext context, {
  required String studentName,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Deactivate Student'),
      content: Text(
        'Are you sure you want to deactivate $studentName? '
        'They will be moved to inactive students.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Deactivate'),
        ),
      ],
    ),
  );
}
