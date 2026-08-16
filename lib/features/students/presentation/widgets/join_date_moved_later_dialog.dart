import 'package:flutter/material.dart';

/// Confirmation dialog shown when a Student's joinDate is edited to a
/// later date and Monthly Records exist before the new date.
/// Returns `true` via [showDialog] if the user confirms deletion.
Future<bool?> showJoinDateMovedLaterDialog(
  BuildContext context, {
  required int monthsToDelete,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete past history?'),
      content: Text(
        'This removes $monthsToDelete month${monthsToDelete == 1 ? '' : 's'} '
        'of history before the new join date — delete them?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
