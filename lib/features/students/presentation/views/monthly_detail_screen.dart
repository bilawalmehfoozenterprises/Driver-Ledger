import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/monthly_record.dart';
import '../../data/repositories/monthly_record_repository.dart';

/// Monthly detail screen - shows payment and vacation details for a specific month
class MonthlyDetailScreen extends StatefulWidget {
  final int studentId;
  final int monthRecordId;

  const MonthlyDetailScreen({
    super.key,
    required this.studentId,
    required this.monthRecordId,
  });

  @override
  State<MonthlyDetailScreen> createState() => _MonthlyDetailScreenState();
}

class _MonthlyDetailScreenState extends State<MonthlyDetailScreen> {
  final _monthlyRecordRepository = MonthlyRecordRepository();

  MonthlyRecord? _record;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecord();
  }

  Future<void> _loadRecord() async {
    setState(() => _isLoading = true);
    final records = await _monthlyRecordRepository.getRecordsForStudent(
      widget.studentId,
    );
    final record = records.firstWhere(
      (r) => r.id == widget.monthRecordId,
      orElse: () => records.first,
    );

    setState(() {
      _record = record;
      _isLoading = false;
    });
  }

  String _monthName(int month) {
    return DateFormat('MMMM').format(DateTime(2024, month));
  }

  Future<void> _recordPayment() async {
    final amountController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Record Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Amount due: Rs. ${_record!.amountDue.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
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

    if (confirmed == true && amountController.text.isNotEmpty) {
      final amount = double.tryParse(amountController.text) ?? 0;
      if (amount > 0) {
        await _monthlyRecordRepository.recordPayment(
          widget.monthRecordId,
          amount,
        );
        _loadRecord();
      }
    }
  }

  Future<void> _recordVacation() async {
    final daysController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Record Vacation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Current vacation days: ${_record?.vacationDays ?? 0}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: daysController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Vacation Days',
                hintText: 'e.g., 3',
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

    if (confirmed == true && daysController.text.isNotEmpty) {
      final days = int.tryParse(daysController.text) ?? 0;
      if (days >= 0) {
        final dailyRate = _record!.expectedFee / 26;
        final deduction = dailyRate * days;
        await _monthlyRecordRepository.recordVacation(
          widget.monthRecordId,
          days,
          deduction,
        );
        _loadRecord();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Month Detail')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final record = _record;
    if (record == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Month Detail')),
        body: const Center(child: Text('Record not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('${_monthName(record.month)} ${record.year}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSummaryCard(record, theme, colorScheme),
          const SizedBox(height: 16),
          _buildActionsCard(record, theme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    MonthlyRecord record,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Summary',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(
              'Expected Fee',
              'Rs. ${record.expectedFee.toStringAsFixed(0)}',
              theme,
              colorScheme,
            ),
            if (record.vacationDays > 0) ...[
              const Divider(height: 24),
              _buildSummaryRow(
                'Vacation Days',
                '${record.vacationDays} days',
                theme,
                colorScheme,
              ),
              const SizedBox(height: 8),
              _buildSummaryRow(
                'Deduction',
                '- Rs. ${record.deductionAmount.toStringAsFixed(0)}',
                theme,
                colorScheme,
                valueColor: colorScheme.tertiary,
              ),
            ],
            const Divider(height: 24),
            _buildSummaryRow(
              'Amount Due',
              'Rs. ${record.amountDue.toStringAsFixed(0)}',
              theme,
              colorScheme,
              isBold: true,
            ),
            const SizedBox(height: 8),
            _buildSummaryRow(
              'Amount Paid',
              'Rs. ${record.totalPaid.toStringAsFixed(0)}',
              theme,
              colorScheme,
              valueColor: record.isFullyPaid ? colorScheme.primary : null,
            ),
            const Divider(height: 24),
            _buildSummaryRow(
              'Balance',
              'Rs. ${record.balance.toStringAsFixed(0)}',
              theme,
              colorScheme,
              isBold: true,
              valueColor: record.isFullyPaid
                  ? colorScheme.primary
                  : record.balance > 0
                  ? colorScheme.error
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    ThemeData theme,
    ColorScheme colorScheme, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: valueColor ?? colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildActionsCard(
    MonthlyRecord record,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: record.isFullyPaid ? null : _recordPayment,
                icon: const Icon(Icons.payment),
                label: Text(
                  record.isFullyPaid ? 'Fully Paid' : 'Record Payment',
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _recordVacation,
                icon: const Icon(Icons.beach_access),
                label: const Text('Record Vacation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
