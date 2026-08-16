import 'package:flutter/material.dart';

/// Dialog for editing a Monthly Record's expected fee.
/// Returns the entered amount if confirmed and valid, otherwise `null`.
Future<double?> showEditExpectedFeeDialog(
  BuildContext context, {
  required double currentExpectedFee,
}) async {
  final feeController = TextEditingController(
    text: currentExpectedFee.toStringAsFixed(0),
  );

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit Expected Fee'),
      content: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          TextField(
            controller: feeController,
            keyboardType: .number,
            decoration: const InputDecoration(
              labelText: 'Expected Fee (Rs.)',
              hintText: 'e.g., 5000',
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

  if (confirmed != true || feeController.text.isEmpty) return null;
  final fee = double.tryParse(feeController.text) ?? 0;
  if (fee <= 0) return null;
  return fee;
}
