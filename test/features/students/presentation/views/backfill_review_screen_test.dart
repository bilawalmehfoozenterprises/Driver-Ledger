import 'package:driver_ledger/features/students/data/models/student.dart';
import 'package:driver_ledger/features/students/data/repositories/monthly_record_repository.dart';
import 'package:driver_ledger/features/students/data/repositories/student_repository.dart';
import 'package:driver_ledger/features/students/presentation/views/backfill_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/fake_monthly_record_repository.dart';
import '../../fakes/fake_student_repository.dart';

void main() {
  testWidgets(
    'lists one row per missing month and updates status live when amount paid changes',
    (tester) async {
      final fakeStudentRepository = FakeStudentRepository(
        students: [
          Student(
            id: 1,
            name: 'Bilal',
            monthlyFee: 3000,
            shift: .both,
            joinDate: DateTime(2024, 3, 1),
            createdAt: DateTime(2024, 3, 1),
          ),
        ],
      );
      final fakeRecordRepository = FakeMonthlyRecordRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            studentRepositoryProvider.overrideWithValue(fakeStudentRepository),
            monthlyRecordRepositoryProvider.overrideWithValue(
              fakeRecordRepository,
            ),
          ],
          child: const MaterialApp(
            home: BackfillReviewScreen(studentId: 1),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('March 2024'), findsOneWidget);
      expect(find.text('Paid'), findsWidgets);

      final amountPaidField = find.widgetWithText(
        TextField,
        'Amount Paid (Rs.)',
      ).first;
      await tester.enterText(amountPaidField, '0');
      await tester.pumpAndSettle();

      expect(find.text('Unpaid'), findsOneWidget);
    },
  );
}
