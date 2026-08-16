import 'package:flutter/material.dart';
import 'package:faker_dart/faker_dart.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/enums/enums.dart';
import '../../data/models/student.dart';
import '../../data/repositories/student_repository.dart';

/// Add/Edit Student screen
class AddStudentScreen extends StatefulWidget {
  final Student? student;

  const AddStudentScreen({super.key, this.student});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _studentRepository = StudentRepository();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _parentNameController = TextEditingController();
  final _parentPhoneController = TextEditingController();
  final _feeController = TextEditingController();
  final _pickupController = TextEditingController();
  final _dropoffController = TextEditingController();

  Shift _selectedShift = Shift.both;
  DateTime _joinDate = DateTime.now();
  bool _isSaving = false;

  bool get _isEditing => widget.student != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final student = widget.student!;
      _nameController.text = student.name;
      _parentNameController.text = student.parentName ?? '';
      _parentPhoneController.text = student.parentPhone ?? '';
      _feeController.text = student.monthlyFee.toStringAsFixed(0);
      _pickupController.text = student.pickupLocation ?? '';
      _dropoffController.text = student.dropoffLocation ?? '';
      _selectedShift = student.shift;
      _joinDate = student.joinDate;
    }
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

  Future<void> _selectJoinDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _joinDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _joinDate = picked);
    }
  }

  void _fillMockData() {
    final faker = Faker.instance;
    faker.setLocale(FakerLocaleType.en_IND);

    _nameController.text = faker.name.fullName();
    _parentNameController.text = faker.name.fullName();
    _parentPhoneController.text = faker.phoneNumber.phoneNumber(
      format: '03#########',
    );
    _feeController.text = (3000 + faker.datatype.number(max: 7) * 1000)
        .toString();
    _pickupController.text = faker.address.streetAddress();
    _dropoffController.text = faker.address.city();
    _selectedShift = Shift.values[faker.datatype.number(max: 2)];
    _joinDate = DateTime.now();

    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mock student details filled')),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final fee = double.tryParse(_feeController.text) ?? 0;

    final student = Student(
      id: widget.student?.id,
      name: _nameController.text.trim(),
      parentName: _parentNameController.text.trim().isEmpty
          ? null
          : _parentNameController.text.trim(),
      parentPhone: _parentPhoneController.text.trim().isEmpty
          ? null
          : _parentPhoneController.text.trim(),
      monthlyFee: fee,
      shift: _selectedShift,
      pickupLocation: _pickupController.text.trim().isEmpty
          ? null
          : _pickupController.text.trim(),
      dropoffLocation: _dropoffController.text.trim().isEmpty
          ? null
          : _dropoffController.text.trim(),
      joinDate: _joinDate,
      isActive: widget.student?.isActive ?? true,
      createdAt: widget.student?.createdAt ?? DateTime.now(),
    );

    if (_isEditing) {
      await _studentRepository.updateStudent(student);
    } else {
      await _studentRepository.insertStudent(student);
    }

    setState(() => _isSaving = false);

    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit student' : 'Add student'),
        actions: [
          IconButton(
            onPressed: _fillMockData,
            tooltip: 'Fill mock data',
            icon: const Icon(Icons.auto_awesome),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Text(
              _isEditing
                  ? 'Update the student details below.'
                  : 'Add the student details you receive from the parent.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text('Student information', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
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
              controller: _parentNameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Parent name (optional)',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _parentPhoneController,
              decoration: const InputDecoration(
                labelText: 'Parent phone (optional)',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _feeController,
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
            const SizedBox(height: 16),
            const SizedBox(height: 24),
            Text('Transport details', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Text('Shift', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            SegmentedButton<Shift>(
              segments: const [
                ButtonSegment(value: Shift.morning, label: Text('Morning')),
                ButtonSegment(value: Shift.afternoon, label: Text('Afternoon')),
                ButtonSegment(value: Shift.both, label: Text('Both')),
              ],
              selected: {_selectedShift},
              onSelectionChanged: (selection) {
                setState(() => _selectedShift = selection.first);
              },
            ),
            const SizedBox(height: 16),
            Card.outlined(
              margin: EdgeInsets.zero,
              child: ListTile(
                leading: const Icon(Icons.calendar_today_outlined),
                title: const Text('Join date'),
                subtitle: Text(DateFormat('dd MMM yyyy').format(_joinDate)),
                trailing: const Icon(Icons.chevron_right),
                onTap: _selectJoinDate,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _pickupController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Pickup location (optional)',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _dropoffController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Drop-off location (optional)',
                prefixIcon: Icon(Icons.school_outlined),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _isSaving ? null : _save,
              icon: _isSaving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check),
              label: Text(_isEditing ? 'Save changes' : 'Add student'),
            ),
          ],
        ),
      ),
    );
  }
}
