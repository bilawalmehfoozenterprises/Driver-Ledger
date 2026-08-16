import '../../../../core/database/database_helper.dart';
import '../models/monthly_record.dart';

class MonthlyRecordRepository {
  Future<int> insert(MonthlyRecord record) async {
    final db = await DatabaseHelper.database;
    return await db.insert('monthly_records', record.toMap());
  }

  Future<List<MonthlyRecord>> getByMonth(int month, int year) async {
    final db = await DatabaseHelper.database;
    final maps = await db.query(
      'monthly_records',
      where: 'month = ? AND year = ?',
      whereArgs: [month, year],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => MonthlyRecord.fromMap(map)).toList();
  }

  Future<List<MonthlyRecord>> getByStudent(int studentId) async {
    final db = await DatabaseHelper.database;
    final maps = await db.query(
      'monthly_records',
      where: 'student_id = ?',
      whereArgs: [studentId],
      orderBy: 'year DESC, month DESC',
    );
    return maps.map((map) => MonthlyRecord.fromMap(map)).toList();
  }

  Future<MonthlyRecord?> getById(int id) async {
    final db = await DatabaseHelper.database;
    final maps = await db.query(
      'monthly_records',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return MonthlyRecord.fromMap(maps.first);
  }

  Future<MonthlyRecord?> getByStudentAndMonth(
    int studentId,
    int month,
    int year,
  ) async {
    final db = await DatabaseHelper.database;
    final maps = await db.query(
      'monthly_records',
      where: 'student_id = ? AND month = ? AND year = ?',
      whereArgs: [studentId, month, year],
    );
    if (maps.isEmpty) return null;
    return MonthlyRecord.fromMap(maps.first);
  }

  Future<void> updateTotalPaid(int id, double totalPaid) async {
    final db = await DatabaseHelper.database;
    await db.update(
      'monthly_records',
      {'total_paid': totalPaid},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> update(MonthlyRecord record) async {
    final db = await DatabaseHelper.database;
    await db.update(
      'monthly_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await DatabaseHelper.database;
    await db.delete('monthly_records', where: 'id = ?', whereArgs: [id]);
  }
}
