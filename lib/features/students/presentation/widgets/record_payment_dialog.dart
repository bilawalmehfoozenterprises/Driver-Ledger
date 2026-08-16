import 'package:flutter/material.dart';

/// Dialog for entering a payment amount.
/// Returns the entered amount if confirmed and valid, otherwise `null`.
Future<double?> showRecordPaymentDialog(
  BuildContext context, {
  required double amountDue,
}) async {
  final amountController = TextEditingController();

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Record Payment'),
      content: Column(
        mainAxisSize: .min,
        children: [
          Text(
            'Amount due: Rs. ${amountDue.toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: amountController,
            keyboardType: .number,
            decoration: const InputDecoration(
              labelText: 'Amount (Rs.)',
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

  if (confirmed != true || amountController.text.isEmpty) return null;
  final amount = double.tryParse(amountController.text) ?? 0;
  if (amount <= 0) return null;
  return amount;
}
