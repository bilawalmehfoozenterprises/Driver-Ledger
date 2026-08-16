import 'package:flutter/material.dart';

/// Student name, parent name, parent phone, and monthly fee form fields.
class StudentInfoFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController parentNameController;
  final TextEditingController parentPhoneController;
  final TextEditingController feeController;

  const StudentInfoFields({
    super.key,
    required this.nameController,
    required this.parentNameController,
    required this.parentPhoneController,
    required this.feeController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: nameController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Student name',
            prefixIcon: Icon(Icons.person_outline),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter student name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: parentNameController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Parent name (optional)',
            prefixIcon: Icon(Icons.person_outline),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: parentPhoneController,
          decoration: const InputDecoration(
            labelText: 'Parent phone (optional)',
            prefixIcon: Icon(Icons.phone_outlined),
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: feeController,
          decoration: const InputDecoration(
            labelText: 'Monthly fee (Rs.)',
            prefixIcon: Icon(Icons.payments_outlined),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter monthly fee';
            }
            final fee = double.tryParse(value);
            if (fee == null || fee <= 0) {
              return 'Please enter a valid amount';
            }
            return null;
          },
        ),
      ],
    );
  }
}
