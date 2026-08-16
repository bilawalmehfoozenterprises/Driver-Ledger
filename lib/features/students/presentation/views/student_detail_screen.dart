import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/enums/enums.dart';
import '../../data/models/student.dart';
import '../../data/models/monthly_record.dart';
import '../../data/repositories/student_repository.dart';
import '../../data/repositories/monthly_record_repository.dart';

/// Student detail screen - shows monthly history
class StudentDetailScreen extends StatefulWidget {
  final int studentId;

  const StudentDetailScreen({super.key, required this.studentId});

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  Student? _student;
  List<MonthlyRecord> _records = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final student = await StudentRepository.getStudent(widget.studentId);

    // Ensure current month record exists
    final now = DateTime.now();
    await MonthlyRecordRepository.getOrCreateRecord(
      widget.studentId,
      now.month,
      now.year,
      student?.monthlyFee ?? 0,
    );

    // Reload records after potential creation
    final records = await MonthlyRecordRepository.getRecordsForStudent(
      widget.studentId,
    );

    setState(() {
      _student = student;
      _records = records;
      _isLoading = false;
    });
  }

  String _monthName(int month) {
    return DateFormat('MMMM').format(DateTime(2024, month));
  }

  String _shiftLabel(Shift shift) {
    switch (shift) {
      case Shift.morning:
        return 'Morning';
      case Shift.afternoon:
        return 'Afternoon';
      case Shift.both:
        return 'Both';
    }
  }

  Color _statusColor(String status, ColorScheme colorScheme) {
    switch (status) {
      case 'Paid':
        return colorScheme.primary;
      case 'Partial':
        return colorScheme.tertiary;
      case 'Unpaid':
        return colorScheme.error;
      default:
        return colorScheme.onSurfaceVariant;
    }
  }

  Future<void> _deactivateStudent() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deactivate Student'),
        content: Text(
          'Are you sure you want to deactivate ${_student?.name}? '
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

    if (confirmed == true) {
      await StudentRepository.deactivateStudent(widget.studentId);
      if (mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Student')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final student = _student;
    if (student == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Student')),
        body: const Center(child: Text('Student not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(student.name),
        actions: [
          if (student.isActive)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await context.push('/students/add', extra: student);
                _loadData();
              },
            ),
          if (student.isActive)
            IconButton(
              icon: const Icon(Icons.person_off),
              onPressed: _deactivateStudent,
            ),
        ],
      ),
      body: Column(
        children: [
          _buildStudentInfo(student, theme, colorScheme),
          Expanded(child: _buildMonthlyList(theme, colorScheme)),
        ],
      ),
    );
  }

  Widget _buildStudentInfo(
    Student student,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(student.name, style: theme.textTheme.titleLarge),
                      Text(
                        'Parent: ${student.parentName ?? 'Not provided'}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Icon(
                  Icons.phone,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  student.parentPhone ?? 'No phone number',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.monetization_on,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  'Rs. ${student.monthlyFee.toStringAsFixed(0)}/month',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  _shiftLabel(student.shift),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  'Joined: ${DateFormat('dd MMM yyyy').format(student.joinDate)}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            if (student.pickupLocation != null ||
                student.dropoffLocation != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      [
                        if (student.pickupLocation != null)
                          'Pickup: ${student.pickupLocation}',
                        if (student.dropoffLocation != null)
                          'Drop: ${student.dropoffLocation}',
                      ].join(' • '),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyList(ThemeData theme, ColorScheme colorScheme) {
    if (_records.isEmpty) {
      return const Center(child: Text('No monthly records'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _records.length,
      itemBuilder: (context, index) {
        final record = _records[index];
        return _buildMonthCard(record, theme, colorScheme);
      },
    );
  }

  Widget _buildMonthCard(
    MonthlyRecord record,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final now = DateTime.now();
    final isCurrentMonth = record.month == now.month && record.year == now.year;

    return Card(
      child: InkWell(
        onTap: () async {
          await context.push(
            '/students/${widget.studentId}/months/${record.id}',
          );
          _loadData();
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${_monthName(record.month)} ${record.year}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: isCurrentMonth
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor(
                        record.status,
                        colorScheme,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      record.status,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _statusColor(record.status, colorScheme),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expected',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        'Rs. ${record.expectedFee.toStringAsFixed(0)}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  if (record.vacationDays > 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Vacation',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          '${record.vacationDays} days',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Paid',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        'Rs. ${record.totalPaid.toStringAsFixed(0)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: record.isFullyPaid
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (record.deductionAmount > 0) ...[
                const SizedBox(height: 8),
                Text(
                  'Deduction: Rs. ${record.deductionAmount.toStringAsFixed(0)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.tertiary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
