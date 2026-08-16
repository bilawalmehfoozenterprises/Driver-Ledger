import '../../../../core/database/database_helper.dart';
import '../models/payment.dart';

class PaymentRepository {
  Future<int> insert(Payment payment) async {
    final db = await DatabaseHelper.database;
    return await db.insert('payments', payment.toMap());
  }

  Future<List<Payment>> getByMonthlyRecord(int monthlyRecordId) async {
    final db = await DatabaseHelper.database;
    final maps = await db.query(
      'payments',
      where: 'monthly_record_id = ?',
      whereArgs: [monthlyRecordId],
      orderBy: 'payment_date ASC',
    );
    return maps.map((map) => Payment.fromMap(map)).toList();
  }

  Future<List<Payment>> getAll() async {
    final db = await DatabaseHelper.database;
    final maps = await db.query('payments', orderBy: 'payment_date DESC');
    return maps.map((map) => Payment.fromMap(map)).toList();
  }

  Future<Payment?> getById(int id) async {
    final db = await DatabaseHelper.database;
    final maps = await db.query('payments', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Payment.fromMap(maps.first);
  }

  Future<void> update(Payment payment) async {
    final db = await DatabaseHelper.database;
    await db.update(
      'payments',
      payment.toMap(),
      where: 'id = ?',
      whereArgs: [payment.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await DatabaseHelper.database;
    await db.delete('payments', where: 'id = ?', whereArgs: [id]);
  }
}
