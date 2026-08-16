import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/enums.dart';
import '../../data/models/student.dart';
import '../../data/repositories/student_repository.dart';

/// Students screen - List of all students
class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List<Student> _activeStudents = [];
  List<Student> _inactiveStudents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    setState(() => _isLoading = true);
    final allStudents = await StudentRepository.getAllStudents();
    setState(() {
      _activeStudents = allStudents.where((s) => s.isActive).toList();
      _inactiveStudents = allStudents.where((s) => !s.isActive).toList();
      _isLoading = false;
    });
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Students')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _activeStudents.isEmpty && _inactiveStudents.isEmpty
          ? _buildEmptyState(theme, colorScheme)
          : _buildStudentList(theme, colorScheme),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/students/add');
          _loadStudents();
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Add Student'),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outlined, size: 80, color: colorScheme.primary),
            const SizedBox(height: 24),
            Text(
              'No Students Yet',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first student to start tracking payments.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentList(ThemeData theme, ColorScheme colorScheme) {
    return RefreshIndicator(
      onRefresh: _loadStudents,
      child: ListView(
        children: [
          if (_activeStudents.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Active Students',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ..._activeStudents.map(
              (student) => _buildStudentCard(student, theme, colorScheme),
            ),
          ],
          if (_inactiveStudents.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'Inactive Students',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ..._inactiveStudents.map(
              (student) => _buildStudentCard(
                student,
                theme,
                colorScheme,
                isInactive: true,
              ),
            ),
          ],
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildStudentCard(
    Student student,
    ThemeData theme,
    ColorScheme colorScheme, {
    bool isInactive = false,
  }) {
    return Card(
      child: InkWell(
        onTap: isInactive
            ? null
            : () async {
                await context.push('/students/${student.id}');
                _loadStudents();
              },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Opacity(
            opacity: isInactive ? 0.6 : 1.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            student.parentPhone ?? 'No phone number',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Rs. ${student.monthlyFee.toStringAsFixed(0)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _shiftLabel(student.shift),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
