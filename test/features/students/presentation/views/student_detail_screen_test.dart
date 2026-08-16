import 'package:driver_ledger/features/students/data/models/monthly_record.dart';
import 'package:driver_ledger/features/students/data/models/student.dart';
import 'package:driver_ledger/features/students/data/repositories/monthly_record_repository.dart';
import 'package:driver_ledger/features/students/data/repositories/student_repository.dart';
import 'package:driver_ledger/features/students/presentation/views/backfill_review_screen.dart';
import 'package:driver_ledger/features/students/presentation/views/student_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../fakes/fake_monthly_record_repository.dart';
import '../../fakes/fake_student_repository.dart';

Student _student({required DateTime joinDate}) {
  return Student(
    id: 1,
    name: 'Bilal',
    monthlyFee: 3000,
    shift: .both,
    joinDate: joinDate,
    createdAt: joinDate,
  );
}

GoRouter _buildRouter() {
  return GoRouter(
    initialLocation: '/students/1',
    routes: [
      GoRoute(
        path: '/students/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return StudentDetailScreen(studentId: id);
        },
      ),
      GoRoute(
        path: '/students/:studentId/backfill',
        name: 'backfill-review',
        builder: (context, state) {
          final studentId = int.parse(state.pathParameters['studentId']!);
          return BackfillReviewScreen(
            studentId: studentId,
            showSkip: state.extra == true,
          );
        },
      ),
      GoRoute(
        path: '/students/:id/edit',
        name: 'edit-student',
        builder: (context, state) => const Scaffold(body: SizedBox.shrink()),
      ),
    ],
  );
}

Widget _buildApp({
  required FakeStudentRepository studentRepository,
  required FakeMonthlyRecordRepository recordRepository,
}) {
  return ProviderScope(
    overrides: [
      studentRepositoryProvider.overrideWithValue(studentRepository),
      monthlyRecordRepositoryProvider.overrideWithValue(recordRepository),
    ],
    child: MaterialApp.router(routerConfig: _buildRouter()),
  );
}

void main() {
  group('StudentDetailScreen Backfill history action', () {
    testWidgets(
      'is visible when the student has missing months',
      (tester) async {
        final studentRepository = FakeStudentRepository(
          students: [_student(joinDate: DateTime(2024, 3, 1))],
        );
        final recordRepository = FakeMonthlyRecordRepository();

        await tester.pumpWidget(
          _buildApp(
            studentRepository: studentRepository,
            recordRepository: recordRepository,
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.widgetWithIcon(IconButton, Icons.history),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'is hidden when the student has no missing months',
      (tester) async {
        final now = DateTime.now();
        final studentRepository = FakeStudentRepository(
          students: [_student(joinDate: DateTime(now.year, now.month, 1))],
        );
        final recordRepository = FakeMonthlyRecordRepository();

        await tester.pumpWidget(
          _buildApp(
            studentRepository: studentRepository,
            recordRepository: recordRepository,
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.widgetWithIcon(IconButton, Icons.history),
          findsNothing,
        );
      },
    );

    testWidgets(
      'is hidden once existing records already cover the full gap',
      (tester) async {
        final now = DateTime.now();
        final studentRepository = FakeStudentRepository(
          students: [_student(joinDate: DateTime(2024, 3, 1))],
        );
        final records = <MonthlyRecord>[];
        var month = 3;
        var year = 2024;
        while (year < now.year || (year == now.year && month < now.month)) {
          records.add(
            MonthlyRecord(
              id: month * 100 + year,
              studentId: 1,
              month: month,
              year: year,
              expectedFee: 3000,
              createdAt: DateTime(year, month, 1),
            ),
          );
          if (month == 12) {
            month = 1;
            year++;
          } else {
            month++;
          }
        }
        final recordRepository = FakeMonthlyRecordRepository(records: records);

        await tester.pumpWidget(
          _buildApp(
            studentRepository: studentRepository,
            recordRepository: recordRepository,
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.widgetWithIcon(IconButton, Icons.history),
          findsNothing,
        );
      },
    );

    testWidgets(
      'tapping the action opens the Backfill review screen pre-populated with the gap',
      (tester) async {
        final studentRepository = FakeStudentRepository(
          students: [_student(joinDate: DateTime(2024, 3, 1))],
        );
        final recordRepository = FakeMonthlyRecordRepository();

        await tester.pumpWidget(
          _buildApp(
            studentRepository: studentRepository,
            recordRepository: recordRepository,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithIcon(IconButton, Icons.history));
        await tester.pumpAndSettle();

        expect(find.byType(BackfillReviewScreen), findsOneWidget);
        expect(find.text('March 2024'), findsOneWidget);
        expect(find.widgetWithText(OutlinedButton, 'Skip'), findsNothing);
      },
    );
  });
}
