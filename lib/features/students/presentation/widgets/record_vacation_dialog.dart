import 'package:flutter/material.dart';

/// Dialog for entering vacation days.
/// Returns the entered day count if confirmed and valid, otherwise `null`.
Future<int?> showRecordVacationDialog(
  BuildContext context, {
  required int currentVacationDays,
}) async {
  final daysController = TextEditingController();

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Record Vacation'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Current vacation days: $currentVacationDays',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: daysController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Vacation Days',
              hintText: 'e.g., 3',
            ),
            autofocus: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Save'),
        ),
      ],
    ),
  );

  if (confirmed != true || daysController.text.isEmpty) return null;
  final days = int.tryParse(daysController.text) ?? 0;
  if (days < 0) return null;
  return days;
}
