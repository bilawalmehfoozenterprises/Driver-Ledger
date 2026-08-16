import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../viewmodels/backfill_review_notifier.dart';
import '../widgets/backfill_row_card.dart';

/// Backfill review screen: lists one editable row per missing month for a
/// Student, lets the driver adjust expected fee / amount paid per row, and
/// saves them as new Monthly Records. Backing out without saving is a
/// no-op.
class BackfillReviewScreen extends ConsumerWidget {
  final int studentId;

  /// When true, shows a "Skip" action that creates each missing month as
  /// Unpaid using the documented prefill rule, bypassing row-by-row review.
  /// Only the new-student creation entry point sets this; other entry
  /// points are already opt-in, so reaching the screen is the opt-in step.
  final bool showSkip;

  const BackfillReviewScreen({
    super.key,
    required this.studentId,
    this.showSkip = false,
  });

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    await ref.read(backfillReviewNotifierProvider(studentId).notifier).save();
    if (context.mounted) context.pop();
  }

  Future<void> _skip(BuildContext context, WidgetRef ref) async {
    await ref.read(backfillReviewNotifierProvider(studentId).notifier).skip();
    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(backfillReviewNotifierProvider(studentId));

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Past Months')),
      body: stateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Failed to load missing months: $error')),
        data: (state) {
          if (state.rows.isEmpty) {
            return const Center(child: Text('No missing months to backfill'));
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            itemCount: state.rows.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final notifier = ref.read(
                backfillReviewNotifierProvider(studentId).notifier,
              );
              return BackfillRowCard(
                row: state.rows[index],
                onExpectedFeeChanged: (fee) =>
                    notifier.updateExpectedFee(index, fee),
                onAmountPaidChanged: (amount) =>
                    notifier.updateAmountPaid(index, amount),
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (showSkip) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _skip(context, ref),
                    child: const Text('Skip'),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _save(context, ref),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
