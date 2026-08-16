/// Named routes for the app, used with `context.pushNamed`/`context.goNamed`
/// instead of raw path strings.
enum AppRoutes {
  home('home', '/'),
  students('students', '/students'),
  addStudent('add-student', '/students/add'),
  editStudent('edit-student', '/students/:id/edit'),
  studentDetail('student-detail', '/students/:id'),
  monthlyDetail(
    'monthly-detail',
    '/students/:studentId/months/:monthId',
  );

  final String name;
  final String path;

  const AppRoutes(this.name, this.path);
}
