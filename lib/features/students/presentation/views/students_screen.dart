import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:driver_ledger/core/enums/enums.dart';
import 'package:driver_ledger/features/students/presentation/viewmodels/student_viewmodel.dart';

class StudentsScreen extends ConsumerWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final studentsAsync = ref.watch(studentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Students')),
      body: studentsAsync.when(
        data: (students) {
          if (students.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 80,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No Students Yet',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first student to get started',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: student.isActive
                        ? colorScheme.primaryContainer
                        : colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.person,
                      color: student.isActive
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                  title: Text(
                    student.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: student.isActive
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        'Parent: ${student.parentName}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Phone: ${student.parentPhone}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            _getShiftIcon(student.shift),
                            size: 16,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getShiftLabel(student.shift),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '\$${student.currentFee.toStringAsFixed(0)}/month',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      final notifier = ref.read(studentsProvider.notifier);
                      switch (value) {
                        case 'activate':
                          await notifier.activate(student.id!);
                          break;
                        case 'deactivate':
                          await notifier.deactivate(student.id!);
                          break;
                        case 'delete':
                          await notifier.delete(student.id!);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      if (!student.isActive)
                        const PopupMenuItem(
                          value: 'activate',
                          child: ListTile(
                            leading: Icon(Icons.person_add),
                            title: Text('Activate'),
                          ),
                        ),
                      if (student.isActive)
                        const PopupMenuItem(
                          value: 'deactivate',
                          child: ListTile(
                            leading: Icon(Icons.person_remove),
                            title: Text('Deactivate'),
                          ),
                        ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete),
                          title: Text('Delete'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/students/add'),
        icon: const Icon(Icons.person_add),
        label: const Text('Add Student'),
      ),
    );
  }

  IconData _getShiftIcon(Shift shift) {
    switch (shift) {
      case Shift.morning:
        return Icons.wb_sunny;
      case Shift.afternoon:
        return Icons.wb_cloudy;
      case Shift.both:
        return Icons.wb_sunny_outlined;
    }
  }

  String _getShiftLabel(Shift shift) {
    switch (shift) {
      case Shift.morning:
        return 'Morning';
      case Shift.afternoon:
        return 'Afternoon';
      case Shift.both:
        return 'Both';
    }
  }
}
