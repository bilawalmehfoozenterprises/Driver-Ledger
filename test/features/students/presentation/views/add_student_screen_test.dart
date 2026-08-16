import 'package:driver_ledger/features/students/data/models/monthly_record.dart';
import 'package:driver_ledger/features/students/data/models/student.dart';
import 'package:driver_ledger/features/students/data/repositories/monthly_record_repository.dart';
import 'package:driver_ledger/features/students/data/repositories/student_repository.dart';
import 'package:driver_ledger/features/students/presentation/viewmodels/add_student_form_notifier.dart';
import 'package:driver_ledger/features/students/presentation/views/add_student_screen.dart';
import 'package:driver_ledger/features/students/presentation/views/backfill_review_screen.dart';
import 'package:driver_ledger/features/students/presentation/widgets/save_student_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../fakes/fake_monthly_record_repository.dart';
import '../../fakes/fake_student_repository.dart';

class _App extends ConsumerWidget {
  final GoRouter router;

  const _App({required this.router});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(routerConfig: router);
  }
}

GoRouter _buildRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(body: SizedBox.shrink()),
      ),
      GoRoute(
        path: '/students/add',
        builder: (context, state) => const AddStudentScreen(studentId: null),
      ),
      GoRoute(
        path: '/students/:id/edit',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return AddStudentScreen(studentId: id);
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
    ],
  );
}

Future<void> _fillRequiredFields(WidgetTester tester) async {
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Student name'),
    'New Student',
  );
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Monthly fee'),
    '3000',
  );
}

Future<void> _tapSaveButton(WidgetTester tester) async {
  await tester.drag(find.byType(ListView), const Offset(0, -600));
  await tester.pumpAndSettle();
  await tester.tap(find.byType(SaveStudentButton));
  await tester.pumpAndSettle();
}

void main() {
  group('AddStudentScreen Backfill trigger', () {
    testWidgets(
      'joinDate in the current month does not open Backfill',
      (tester) async {
        final router = _buildRouter();
        final studentRepository = FakeStudentRepository();
        final recordRepository = FakeMonthlyRecordRepository();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              studentRepositoryProvider.overrideWithValue(studentRepository),
              monthlyRecordRepositoryProvider.overrideWithValue(
                recordRepository,
              ),
            ],
            child: _App(router: router),
          ),
        );
        await tester.pumpAndSettle();
        router.push('/students/add');
        await tester.pumpAndSettle();

        await _fillRequiredFields(tester);
        await _tapSaveButton(tester);

        expect(find.byType(BackfillReviewScreen), findsNothing);
        expect(studentRepository.students, hasLength(1));
      },
    );

    testWidgets(
      'joinDate before the current month opens Backfill with skip enabled',
      (tester) async {
        final router = _buildRouter();
        final studentRepository = FakeStudentRepository();
        final recordRepository = FakeMonthlyRecordRepository();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              studentRepositoryProvider.overrideWithValue(studentRepository),
              monthlyRecordRepositoryProvider.overrideWithValue(
                recordRepository,
              ),
            ],
            child: _App(router: router),
          ),
        );
        await tester.pumpAndSettle();
        router.push('/students/add');
        await tester.pumpAndSettle();

        final container = ProviderScope.containerOf(
          tester.element(find.byType(AddStudentScreen)),
        );
        container
            .read(addStudentFormNotifierProvider(null).notifier)
            .updateJoinDate(DateTime(2024, 3, 15));

        await _fillRequiredFields(tester);
        await _tapSaveButton(tester);

        expect(find.byType(BackfillReviewScreen), findsOneWidget);
        expect(find.widgetWithText(OutlinedButton, 'Skip'), findsOneWidget);
        expect(studentRepository.students, hasLength(1));
      },
    );

    testWidgets(
      'skipping Backfill creates each missing month as Unpaid',
      (tester) async {
        final router = _buildRouter();
        final studentRepository = FakeStudentRepository();
        final recordRepository = FakeMonthlyRecordRepository();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              studentRepositoryProvider.overrideWithValue(studentRepository),
              monthlyRecordRepositoryProvider.overrideWithValue(
                recordRepository,
              ),
            ],
            child: _App(router: router),
          ),
        );
        await tester.pumpAndSettle();
        router.push('/students/add');
        await tester.pumpAndSettle();

        final container = ProviderScope.containerOf(
          tester.element(find.byType(AddStudentScreen)),
        );
        container
            .read(addStudentFormNotifierProvider(null).notifier)
            .updateJoinDate(DateTime(2024, 3, 15));

        await _fillRequiredFields(tester);
        await _tapSaveButton(tester);

        await tester.tap(find.widgetWithText(OutlinedButton, 'Skip'));
        await tester.pumpAndSettle();

        final studentId = studentRepository.students.first.id!;
        final records = await recordRepository.getRecordsForStudent(
          studentId,
        );
        expect(records, isNotEmpty);
        for (final record in records) {
          expect(record.totalPaid, 0);
        }
      },
    );
  });

  group('AddStudentScreen join-date-edited-earlier trigger', () {
    testWidgets(
      'editing joinDate earlier with existing records opens Backfill bounded to the newly exposed gap',
      (tester) async {
        final router = _buildRouter();
        final existingStudent = Student(
          id: 1,
          name: 'Bilal',
          monthlyFee: 3000,
          shift: .both,
          joinDate: DateTime(2024, 3, 1),
          createdAt: DateTime(2024, 3, 1),
        );
        final studentRepository = FakeStudentRepository(
          students: [existingStudent],
        );
        final recordRepository = FakeMonthlyRecordRepository(
          records: [
            MonthlyRecord(
              id: 1,
              studentId: 1,
              month: 3,
              year: 2024,
              expectedFee: 3000,
              createdAt: DateTime(2024, 3, 1),
            ),
            MonthlyRecord(
              id: 2,
              studentId: 1,
              month: 4,
              year: 2024,
              expectedFee: 3000,
              createdAt: DateTime(2024, 4, 1),
            ),
          ],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              studentRepositoryProvider.overrideWithValue(studentRepository),
              monthlyRecordRepositoryProvider.overrideWithValue(
                recordRepository,
              ),
            ],
            child: _App(router: router),
          ),
        );
        await tester.pumpAndSettle();
        router.push('/students/1/edit');
        await tester.pumpAndSettle();

        final container = ProviderScope.containerOf(
          tester.element(find.byType(AddStudentScreen)),
        );
        container
            .read(addStudentFormNotifierProvider(1).notifier)
            .updateJoinDate(DateTime(2024, 1, 1));

        await _tapSaveButton(tester);

        expect(find.byType(BackfillReviewScreen), findsOneWidget);
        // Only January and February 2024 are newly exposed; March/April
        // already have records and must not be re-presented.
        expect(find.text('January 2024'), findsOneWidget);
        expect(find.text('February 2024'), findsOneWidget);
        expect(find.text('March 2024'), findsNothing);
        expect(find.text('April 2024'), findsNothing);
        // This entry point does not support skipping.
        expect(find.widgetWithText(OutlinedButton, 'Skip'), findsNothing);
      },
    );

    testWidgets(
      'editing joinDate earlier with no existing records falls through to normal save',
      (tester) async {
        final router = _buildRouter();
        final existingStudent = Student(
          id: 1,
          name: 'Bilal',
          monthlyFee: 3000,
          shift: .both,
          joinDate: DateTime(2024, 3, 1),
          createdAt: DateTime(2024, 3, 1),
        );
        final studentRepository = FakeStudentRepository(
          students: [existingStudent],
        );
        final recordRepository = FakeMonthlyRecordRepository();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              studentRepositoryProvider.overrideWithValue(studentRepository),
              monthlyRecordRepositoryProvider.overrideWithValue(
                recordRepository,
              ),
            ],
            child: _App(router: router),
          ),
        );
        await tester.pumpAndSettle();
        router.push('/students/1/edit');
        await tester.pumpAndSettle();

        final container = ProviderScope.containerOf(
          tester.element(find.byType(AddStudentScreen)),
        );
        container
            .read(addStudentFormNotifierProvider(1).notifier)
            .updateJoinDate(DateTime(2024, 1, 1));

        await _tapSaveButton(tester);

        expect(find.byType(BackfillReviewScreen), findsNothing);
        expect(
          studentRepository.students.first.joinDate,
          DateTime(2024, 1, 1),
        );
      },
    );
  });

  group('AddStudentScreen join-date-edited-later trigger', () {
    Student existingStudent() => Student(
      id: 1,
      name: 'Bilal',
      monthlyFee: 3000,
      shift: .both,
      joinDate: DateTime(2024, 3, 1),
      createdAt: DateTime(2024, 3, 1),
    );

    List<MonthlyRecord> existingRecords() => [
      MonthlyRecord(
        id: 1,
        studentId: 1,
        month: 3,
        year: 2024,
        expectedFee: 3000,
        createdAt: DateTime(2024, 3, 1),
      ),
      MonthlyRecord(
        id: 2,
        studentId: 1,
        month: 4,
        year: 2024,
        expectedFee: 3000,
        createdAt: DateTime(2024, 4, 1),
      ),
      MonthlyRecord(
        id: 3,
        studentId: 1,
        month: 5,
        year: 2024,
        expectedFee: 3000,
        createdAt: DateTime(2024, 5, 1),
      ),
    ];

    testWidgets(
      'confirming the dialog deletes the affected records and saves the new joinDate',
      (tester) async {
        final router = _buildRouter();
        final studentRepository = FakeStudentRepository(
          students: [existingStudent()],
        );
        final recordRepository = FakeMonthlyRecordRepository(
          records: existingRecords(),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              studentRepositoryProvider.overrideWithValue(studentRepository),
              monthlyRecordRepositoryProvider.overrideWithValue(
                recordRepository,
              ),
            ],
            child: _App(router: router),
          ),
        );
        await tester.pumpAndSettle();
        router.push('/students/1/edit');
        await tester.pumpAndSettle();

        final container = ProviderScope.containerOf(
          tester.element(find.byType(AddStudentScreen)),
        );
        // Moves joinDate to May 1st: a clean month boundary. March and
        // April (strictly before) must be deleted; May (same month) is
        // reprorated, not deleted.
        container
            .read(addStudentFormNotifierProvider(1).notifier)
            .updateJoinDate(DateTime(2024, 5, 1));

        await _tapSaveButton(tester);
        await tester.pumpAndSettle();

        expect(
          find.textContaining('This removes 2 months of history'),
          findsOneWidget,
        );

        await tester.tap(find.widgetWithText(TextButton, 'Delete'));
        await tester.pumpAndSettle();

        final remaining = await recordRepository.getRecordsForStudent(1);
        expect(remaining.map((r) => r.month), [5]);
        expect(
          studentRepository.students.first.joinDate,
          DateTime(2024, 5, 1),
        );
      },
    );

    testWidgets(
      'canceling the dialog aborts the entire edit: no deletion, no date change',
      (tester) async {
        final router = _buildRouter();
        final studentRepository = FakeStudentRepository(
          students: [existingStudent()],
        );
        final recordRepository = FakeMonthlyRecordRepository(
          records: existingRecords(),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              studentRepositoryProvider.overrideWithValue(studentRepository),
              monthlyRecordRepositoryProvider.overrideWithValue(
                recordRepository,
              ),
            ],
            child: _App(router: router),
          ),
        );
        await tester.pumpAndSettle();
        router.push('/students/1/edit');
        await tester.pumpAndSettle();

        final container = ProviderScope.containerOf(
          tester.element(find.byType(AddStudentScreen)),
        );
        container
            .read(addStudentFormNotifierProvider(1).notifier)
            .updateJoinDate(DateTime(2024, 5, 1));

        await _tapSaveButton(tester);
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
        await tester.pumpAndSettle();

        final remaining = await recordRepository.getRecordsForStudent(1);
        expect(remaining, hasLength(3));
        expect(
          studentRepository.students.first.joinDate,
          DateTime(2024, 3, 1),
        );
        // The edit is aborted entirely: still on the edit screen.
        expect(find.byType(AddStudentScreen), findsOneWidget);
      },
    );

    testWidgets(
      'joinDate moved later into the same month as an existing record reprorates that record instead of deleting it',
      (tester) async {
        final router = _buildRouter();
        final studentRepository = FakeStudentRepository(
          students: [existingStudent()],
        );
        final recordRepository = FakeMonthlyRecordRepository(
          records: existingRecords(),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              studentRepositoryProvider.overrideWithValue(studentRepository),
              monthlyRecordRepositoryProvider.overrideWithValue(
                recordRepository,
              ),
            ],
            child: _App(router: router),
          ),
        );
        await tester.pumpAndSettle();
        router.push('/students/1/edit');
        await tester.pumpAndSettle();

        final container = ProviderScope.containerOf(
          tester.element(find.byType(AddStudentScreen)),
        );
        // May 2024 has 31 days; moving joinDate to the 16th leaves 16
        // remaining days (16..31 inclusive).
        container
            .read(addStudentFormNotifierProvider(1).notifier)
            .updateJoinDate(DateTime(2024, 5, 16));

        await _tapSaveButton(tester);
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(TextButton, 'Delete'));
        await tester.pumpAndSettle();

        final remaining = await recordRepository.getRecordsForStudent(1);
        expect(remaining.map((r) => r.month), [5]);
        expect(remaining.first.expectedFee, (3000 / 31) * 16);
      },
    );

    testWidgets(
      'no records before the new joinDate does not show the dialog',
      (tester) async {
        final router = _buildRouter();
        final studentRepository = FakeStudentRepository(
          students: [existingStudent()],
        );
        final recordRepository = FakeMonthlyRecordRepository();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              studentRepositoryProvider.overrideWithValue(studentRepository),
              monthlyRecordRepositoryProvider.overrideWithValue(
                recordRepository,
              ),
            ],
            child: _App(router: router),
          ),
        );
        await tester.pumpAndSettle();
        router.push('/students/1/edit');
        await tester.pumpAndSettle();

        final container = ProviderScope.containerOf(
          tester.element(find.byType(AddStudentScreen)),
        );
        container
            .read(addStudentFormNotifierProvider(1).notifier)
            .updateJoinDate(DateTime(2024, 5, 1));

        await _tapSaveButton(tester);

        expect(
          find.textContaining('This removes'),
          findsNothing,
        );
        expect(
          studentRepository.students.first.joinDate,
          DateTime(2024, 5, 1),
        );
      },
    );
  });
}
