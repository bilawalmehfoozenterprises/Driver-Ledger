import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../students/data/repositories/student_repository.dart';
import '../../../students/data/repositories/monthly_record_repository.dart';

/// Home screen - Dashboard with summary and unpaid/partial students
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _studentRepository = StudentRepository();
  final _monthlyRecordRepository = MonthlyRecordRepository();

  int _activeStudents = 0;
  double _totalExpected = 0;
  double _totalCollected = 0;
  double _totalOutstanding = 0;
  List<Map<String, dynamic>> _unpaidStudents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() => _isLoading = true);

    final students = await _studentRepository.getActiveStudents();
    final now = DateTime.now();
    final summary = await _monthlyRecordRepository.getMonthlySummary(
      now.month,
      now.year,
    );

    // Get unpaid/partial students
    final unpaidStudents = <Map<String, dynamic>>[];
    for (final student in students) {
      final record = await _monthlyRecordRepository.getOrCreateRecord(
        student.id!,
        now.month,
        now.year,
        student.monthlyFee,
      );
      if (!record.isFullyPaid) {
        unpaidStudents.add({'student': student, 'record': record});
      }
    }

    setState(() {
      _activeStudents = students.length;
      _totalExpected = summary['expected']!;
      _totalCollected = summary['collected']!;
      _totalOutstanding = _totalExpected - _totalCollected;
      _unpaidStudents = unpaidStudents;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Driver Ledger')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadDashboard,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSummaryCards(theme, colorScheme),
                  const SizedBox(height: 24),
                  _buildUnpaidSection(theme, colorScheme),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryCards(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Active Students',
                _activeStudents.toString(),
                Icons.people,
                colorScheme.primary,
                theme,
                colorScheme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Expected',
                'Rs. ${_totalExpected.toStringAsFixed(0)}',
                Icons.monetization_on,
                colorScheme.secondary,
                theme,
                colorScheme,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Collected',
                'Rs. ${_totalCollected.toStringAsFixed(0)}',
                Icons.check_circle,
                colorScheme.primary,
                theme,
                colorScheme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Outstanding',
                'Rs. ${_totalOutstanding.toStringAsFixed(0)}',
                Icons.pending,
                colorScheme.error,
                theme,
                colorScheme,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String label,
    String value,
    IconData icon,
    Color color,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: .bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnpaidSection(ThemeData theme, ColorScheme colorScheme) {
    if (_unpaidStudents.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 48,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  'All students paid!',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          'Unpaid / Partial',
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        ..._unpaidStudents.map((item) {
          final student = item['student'];
          final record = item['record'];
          return _buildUnpaidCard(student, record, theme, colorScheme);
        }),
      ],
    );
  }

  Widget _buildUnpaidCard(
    dynamic student,
    dynamic record,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final statusColor = record.status == 'Partial'
        ? colorScheme.tertiary
        : colorScheme.error;

    return Card(
      child: InkWell(
        onTap: () async {
          await context.push('/students/${student.id}');
          _loadDashboard();
        },
        borderRadius: .circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(student.name, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      'Rs. ${record.totalPaid.toStringAsFixed(0)} / Rs. ${record.amountDue.toStringAsFixed(0)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: .circular(8),
                ),
                child: Text(
                  record.status,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: .bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
