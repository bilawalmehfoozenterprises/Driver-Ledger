import 'package:flutter/material.dart';

/// Submit button for the add/edit student form.
class SaveStudentButton extends StatelessWidget {
  final bool isSaving;
  final bool isEditing;
  final VoidCallback? onPressed;

  const SaveStudentButton({
    super.key,
    required this.isSaving,
    required this.isEditing,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: isSaving ? null : onPressed,
      icon: isSaving
          ? const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.check),
      label: Text(isEditing ? 'Save changes' : 'Add student'),
    );
  }
}
