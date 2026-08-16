import '../../../../core/database/database_helper.dart';
import '../models/student.dart';

class StudentRepository {
  static Future<List<Student>> getAllStudents() async {
    final db = await DatabaseHelper.database;
    final maps = await db.query('students', orderBy: 'name ASC');
    return maps.map((map) => Student.fromMap(map)).toList();
  }

  static Future<List<Student>> getActiveStudents() async {
    final db = await DatabaseHelper.database;
    final maps = await db.query(
      'students',
      where: 'is_active = ?',
      whereArgs: [1],
      orderBy: 'name ASC',
    );
    return maps.map((map) => Student.fromMap(map)).toList();
  }

  static Future<Student?> getStudent(int id) async {
    final db = await DatabaseHelper.database;
    final maps = await db.query('students', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Student.fromMap(maps.first);
  }

  static Future<int> insertStudent(Student student) async {
    final db = await DatabaseHelper.database;
    return await db.insert('students', student.toMap());
  }

  static Future<void> updateStudent(Student student) async {
    final db = await DatabaseHelper.database;
    await db.update(
      'students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  static Future<void> deactivateStudent(int id) async {
    final db = await DatabaseHelper.database;
    await db.update(
      'students',
      {'is_active': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
