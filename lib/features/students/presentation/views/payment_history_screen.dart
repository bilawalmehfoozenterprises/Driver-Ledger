import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../data/models/monthly_record.dart';
import '../viewmodels/student_detail_notifier.dart';
import '../widgets/monthly_records_list.dart';

/// Full payment history for a student, excluding the current month
/// (which is shown and acted on directly from the student detail screen).
class PaymentHistoryScreen extends ConsumerWidget {
  final int studentId;

  const PaymentHistoryScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(studentDetailNotifierProvider(studentId));

    return Scaffold(
      appBar: AppBar(title: const Text('Payment History')),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Failed to load history: $error')),
        data: (state) {
          final pastRecords = state.records.isEmpty
              ? state.records
              : state.records.skip(1).toList();

          if (pastRecords.isEmpty) {
            return const Center(child: Text('No past months yet'));
          }

          return ListView(
            children: [
              const SizedBox(height: 16),
              MonthlyRecordsList(
                records: pastRecords,
                onRecordTap: (MonthlyRecord record) async {
                  await context.pushNamed(
                    AppRoutes.monthlyDetail.name,
                    pathParameters: {
                      'studentId': studentId.toString(),
                      'monthId': record.id.toString(),
                    },
                  );
                  ref.invalidate(studentDetailNotifierProvider(studentId));
                },
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}
