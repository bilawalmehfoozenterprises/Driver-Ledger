import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../domain/backfill_calculator.dart';
import '../viewmodels/add_student_form_notifier.dart';
import '../widgets/fill_mock_data_button.dart';
import '../widgets/save_student_button.dart';
import '../widgets/student_info_fields.dart';
import '../widgets/transport_details_fields.dart';

/// Add/Edit Student screen
class AddStudentScreen extends ConsumerStatefulWidget {
  final int? studentId;

  const AddStudentScreen({super.key, required this.studentId});

  @override
  ConsumerState<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends ConsumerState<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _parentNameController = TextEditingController();
  final _parentPhoneController = TextEditingController();
  final _feeController = TextEditingController();
  final _pickupController = TextEditingController();
  final _dropoffController = TextEditingController();

  bool _controllersInitialized = false;

  void _syncControllers(AddStudentFormState formState) {
    _nameController.text = formState.name;
    _parentNameController.text = formState.parentName;
    _parentPhoneController.text = formState.parentPhone;
    _feeController.text = formState.monthlyFee;
    _pickupController.text = formState.pickupLocation;
    _dropoffController.text = formState.dropoffLocation;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _parentNameController.dispose();
    _parentPhoneController.dispose();
    _feeController.dispose();
    _pickupController.dispose();
    _dropoffController.dispose();
    super.dispose();
  }

  Future<void> _selectJoinDate(DateTime currentJoinDate) async {
    final notifier = ref.read(
      addStudentFormNotifierProvider(widget.studentId).notifier,
    );
    final picked = await showDatePicker(
      context: context,
      initialDate: currentJoinDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      notifier.updateJoinDate(picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final isNewStudent = widget.studentId == null;

    final student = await ref
        .read(addStudentFormNotifierProvider(widget.studentId).notifier)
        .save();

    if (!mounted) return;

    if (isNewStudent) {
      final now = DateTime.now();
      final hasGap = calculateMissingMonths(
        joinDate: student.joinDate,
        now: now,
        existingRecords: const [],
      ).isNotEmpty;

      if (hasGap) {
        context.pushReplacementNamed(
          AppRoutes.backfillReview.name,
          pathParameters: {'studentId': student.id.toString()},
          extra: true,
        );
        return;
      }
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final formState = ref.watch(addStudentFormNotifierProvider(widget.studentId));
    final notifier = ref.read(
      addStudentFormNotifierProvider(widget.studentId).notifier,
    );
    final isEditing = formState.isEditing;

    if (formState.isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(isEditing ? 'Edit student' : 'Add student')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (!_controllersInitialized) {
      _syncControllers(formState);
      _controllersInitialized = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit student' : 'Add student'),
        actions: [
          if (kDebugMode)
            FillMockDataButton(
              studentId: widget.studentId,
              onFilled: () => _syncControllers(
                ref.read(addStudentFormNotifierProvider(widget.studentId)),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: .fromLTRB(
            16,
            8,
            16,
            32 + MediaQuery.of(context).padding.bottom,
          ),
          children: [
            Text(
              isEditing
                  ? 'Update the student details below.'
                  : 'Add the student details you receive from the parent.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text('Student information', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            StudentInfoFields(
              nameController: _nameController,
              parentNameController: _parentNameController,
              parentPhoneController: _parentPhoneController,
              feeController: _feeController,
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 16),
            Text('Transport details', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            TransportDetailsFields(
              selectedShift: formState.shift,
              onShiftChanged: notifier.updateShift,
              joinDate: formState.joinDate,
              onSelectJoinDate: () => _selectJoinDate(formState.joinDate),
              pickupController: _pickupController,
              dropoffController: _dropoffController,
            ),
            const SizedBox(height: 24),
            SaveStudentButton(
              isSaving: formState.isSaving,
              isEditing: isEditing,
              onPressed: () {
                notifier
                  ..updateName(_nameController.text)
                  ..updateParentName(_parentNameController.text)
                  ..updateParentPhone(_parentPhoneController.text)
                  ..updateMonthlyFee(_feeController.text)
                  ..updatePickupLocation(_pickupController.text)
                  ..updateDropoffLocation(_dropoffController.text);
                _save();
              },
            ),
          ],
        ),
      ),
    );
  }
}
