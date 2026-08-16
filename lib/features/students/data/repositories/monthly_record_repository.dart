import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/database_helper.dart';
import '../models/monthly_record.dart';

part 'monthly_record_repository.g.dart';

class MonthlyRecordRepository {
  Future<MonthlyRecord?> getRecord(int studentId, int month, int year) async {
    final db = await DatabaseHelper.database;
    final maps = await db.query(
      'monthly_records',
      where: 'student_id = ? AND month = ? AND year = ?',
      whereArgs: [studentId, month, year],
    );
    if (maps.isEmpty) return null;
    return MonthlyRecord.fromMap(maps.first);
  }

  Future<MonthlyRecord> getOrCreateRecord(
    int studentId,
    int month,
    int year,
    double expectedFee,
  ) async {
    final existing = await getRecord(studentId, month, year);
    if (existing != null) return existing;

    final record = MonthlyRecord(
      studentId: studentId,
      month: month,
      year: year,
      expectedFee: expectedFee,
      createdAt: DateTime.now(),
    );

    final id = await insertRecord(record);
    return record.copyWith(id: id);
  }

  Future<List<MonthlyRecord>> getRecordsForStudent(int studentId) async {
    final db = await DatabaseHelper.database;
    final maps = await db.query(
      'monthly_records',
      where: 'student_id = ?',
      whereArgs: [studentId],
      orderBy: 'year DESC, month DESC',
    );
    return maps.map((map) => MonthlyRecord.fromMap(map)).toList();
  }

  Future<int> insertRecord(MonthlyRecord record) async {
    final db = await DatabaseHelper.database;
    return await db.insert('monthly_records', record.toMap());
  }

  Future<void> updateRecord(MonthlyRecord record) async {
    final db = await DatabaseHelper.database;
    await db.update(
      'monthly_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<void> recordPayment(int recordId, double amount) async {
    final record = await _getRecordById(recordId);
    if (record == null) return;

    final updated = record.copyWith(totalPaid: record.totalPaid + amount);
    await updateRecord(updated);
  }

  Future<void> recordVacation(
    int recordId,
    int vacationDays,
    double deductionAmount,
  ) async {
    final record = await _getRecordById(recordId);
    if (record == null) return;

    final updated = record.copyWith(
      vacationDays: vacationDays,
      deductionAmount: deductionAmount,
    );
    await updateRecord(updated);
  }

  Future<MonthlyRecord?> _getRecordById(int recordId) async {
    final db = await DatabaseHelper.database;
    final maps = await db.query(
      'monthly_records',
      where: 'id = ?',
      whereArgs: [recordId],
    );
    if (maps.isEmpty) return null;
    return MonthlyRecord.fromMap(maps.first);
  }

  Future<Map<String, double>> getMonthlySummary(int month, int year) async {
    final db = await DatabaseHelper.database;
    final result = await db.rawQuery(
      '''
      SELECT
        SUM(mr.expected_fee) as total_expected,
        SUM(mr.deduction_amount) as total_deductions,
        SUM(mr.total_paid) as total_collected
      FROM monthly_records mr
      JOIN students s ON mr.student_id = s.id
      WHERE mr.month = ? AND mr.year = ? AND s.is_active = 1
    ''',
      [month, year],
    );

    if (result.isEmpty || result.first['total_expected'] == null) {
      return {'expected': 0, 'deductions': 0, 'collected': 0};
    }

    return {
      'expected': (result.first['total_expected'] as num).toDouble(),
      'deductions': (result.first['total_deductions'] as num?)?.toDouble() ?? 0,
      'collected': (result.first['total_collected'] as num?)?.toDouble() ?? 0,
    };
  }
}

@riverpod
MonthlyRecordRepository monthlyRecordRepository(Ref ref) =>
    MonthlyRecordRepository();
