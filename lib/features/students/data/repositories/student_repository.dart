import '../../../../core/database/database_helper.dart';
import '../models/student.dart';

class StudentRepository {
  Future<int> insert(Student student) async {
    final db = await DatabaseHelper.database;
    return await db.insert('students', student.toMap());
  }

  Future<List<Student>> getAll() async {
    final db = await DatabaseHelper.database;
    final maps = await db.query('students', orderBy: 'created_at DESC');
    return maps.map((map) => Student.fromMap(map)).toList();
  }

  Future<List<Student>> getActive() async {
    final db = await DatabaseHelper.database;
    final maps = await db.query(
      'students',
      where: 'is_active = ?',
      whereArgs: [1],
      orderBy: 'name ASC',
    );
    return maps.map((map) => Student.fromMap(map)).toList();
  }

  Future<Student?> getById(int id) async {
    final db = await DatabaseHelper.database;
    final maps = await db.query('students', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Student.fromMap(maps.first);
  }

  Future<void> update(Student student) async {
    final db = await DatabaseHelper.database;
    await db.update(
      'students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  Future<void> deactivate(int id) async {
    final db = await DatabaseHelper.database;
    await db.update(
      'students',
      {'is_active': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> activate(int id) async {
    final db = await DatabaseHelper.database;
    await db.update(
      'students',
      {'is_active': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete(int id) async {
    final db = await DatabaseHelper.database;
    await db.delete('students', where: 'id = ?', whereArgs: [id]);
  }
}
