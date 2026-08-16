import 'package:driver_ledger/features/students/data/models/monthly_record.dart';
import 'package:driver_ledger/features/students/data/repositories/monthly_record_repository.dart';

/// In-memory fake of [MonthlyRecordRepository] for use in provider overrides.
class FakeMonthlyRecordRepository implements MonthlyRecordRepository {
  final List<MonthlyRecord> records;
  int _nextId;

  FakeMonthlyRecordRepository({List<MonthlyRecord>? records})
    : records = records ?? [],
      _nextId = (records?.map((r) => r.id ?? 0).fold(0, (a, b) => a > b ? a : b) ?? 0) + 1;

  @override
  Future<MonthlyRecord?> getRecord(int studentId, int month, int year) async {
    try {
      return records.firstWhere(
        (r) => r.studentId == studentId && r.month == month && r.year == year,
      );
    } catch (_) {
      return null;
    }
  }

  @override
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

  @override
  Future<List<MonthlyRecord>> getRecordsForStudent(int studentId) async {
    return records.where((r) => r.studentId == studentId).toList()
      ..sort((a, b) {
        final yearCompare = b.year.compareTo(a.year);
        if (yearCompare != 0) return yearCompare;
        return b.month.compareTo(a.month);
      });
  }

  @override
  Future<int> insertRecord(MonthlyRecord record) async {
    final id = _nextId++;
    records.add(record.copyWith(id: id));
    return id;
  }

  @override
  Future<void> updateRecord(MonthlyRecord record) async {
    final index = records.indexWhere((r) => r.id == record.id);
    if (index != -1) {
      records[index] = record;
    }
  }

  @override
  Future<void> recordPayment(int recordId, double amount) async {
    final record = await _getRecordById(recordId);
    if (record == null) return;

    final updated = record.copyWith(totalPaid: record.totalPaid + amount);
    await updateRecord(updated);
  }

  @override
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
    try {
      return records.firstWhere((r) => r.id == recordId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Map<String, double>> getMonthlySummary(int month, int year) async {
    throw UnimplementedError('Not needed for current notifier tests');
  }
}
