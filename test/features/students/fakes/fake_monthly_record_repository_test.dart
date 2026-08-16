import 'package:driver_ledger/features/students/data/models/monthly_record.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_monthly_record_repository.dart';

MonthlyRecord _record({int? id, int month = 1, int year = 2024}) {
  return MonthlyRecord(
    id: id,
    studentId: 1,
    month: month,
    year: year,
    expectedFee: 5000,
    createdAt: DateTime(year, month, 1),
  );
}

void main() {
  group('FakeMonthlyRecordRepository', () {
    test('deleteRecord removes the record with the matching id', () async {
      final repository = FakeMonthlyRecordRepository(
        records: [_record(id: 1), _record(id: 2, month: 2)],
      );

      await repository.deleteRecord(1);

      final remaining = await repository.getRecordsForStudent(1);
      expect(remaining.map((r) => r.id), [2]);
    });

    test('deleteRecord on an unknown id is a no-op', () async {
      final repository = FakeMonthlyRecordRepository(records: [_record(id: 1)]);

      await repository.deleteRecord(999);

      final remaining = await repository.getRecordsForStudent(1);
      expect(remaining.map((r) => r.id), [1]);
    });

    test('insertRecords inserts all records and returns their assigned ids', () async {
      final repository = FakeMonthlyRecordRepository();

      final ids = await repository.insertRecords([
        _record(month: 3),
        _record(month: 4),
        _record(month: 5),
      ]);

      expect(ids.length, 3);
      expect(ids.toSet().length, 3);

      final saved = await repository.getRecordsForStudent(1);
      expect(saved.length, 3);
      expect(saved.map((r) => r.month).toSet(), {3, 4, 5});
    });
  });
}
