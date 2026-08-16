import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/home/presentation/views/home_screen.dart';
import '../../features/students/presentation/views/students_screen.dart';
import '../../features/students/presentation/views/add_student_screen.dart';
import '../../features/students/presentation/views/student_detail_screen.dart';
import '../../features/students/presentation/views/monthly_detail_screen.dart';
import '../../shared/widgets/app_scaffold.dart';
import 'app_routes.dart';

/// Main router provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home.path,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AppScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.home.path,
            name: AppRoutes.home.name,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: AppRoutes.students.path,
            name: AppRoutes.students.name,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: StudentsScreen()),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.addStudent.path,
        name: AppRoutes.addStudent.name,
        builder: (context, state) => const AddStudentScreen(studentId: null),
      ),
      GoRoute(
        path: AppRoutes.editStudent.path,
        name: AppRoutes.editStudent.name,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return AddStudentScreen(studentId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.studentDetail.path,
        name: AppRoutes.studentDetail.name,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return StudentDetailScreen(studentId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.monthlyDetail.path,
        name: AppRoutes.monthlyDetail.name,
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
