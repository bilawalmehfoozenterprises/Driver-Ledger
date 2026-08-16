import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/home/presentation/views/home_screen.dart';
import '../../features/students/presentation/views/students_screen.dart';
import '../../features/students/presentation/views/add_student_screen.dart';
import '../../features/students/presentation/views/student_detail_screen.dart';
import '../../features/students/presentation/views/monthly_detail_screen.dart';
import '../../shared/widgets/app_scaffold.dart';

/// Main router provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AppScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: '/students',
            name: 'students',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: StudentsScreen()),
          ),
        ],
      ),
      GoRoute(
        path: '/students/add',
        name: 'add-student',
        builder: (context, state) => const AddStudentScreen(),
      ),
      GoRoute(
        path: '/students/:id',
        name: 'student-detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return StudentDetailScreen(studentId: id);
        },
      ),
      GoRoute(
        path: '/students/:studentId/months/:monthId',
        name: 'monthly-detail',
        builder: (context, state) {
          final studentId = int.parse(state.pathParameters['studentId']!);
          final monthId = int.parse(state.pathParameters['monthId']!);
          return MonthlyDetailScreen(
            studentId: studentId,
            monthRecordId: monthId,
          );
        },
      ),
    ],
  );
});
