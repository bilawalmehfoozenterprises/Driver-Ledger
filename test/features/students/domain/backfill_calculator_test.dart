import 'package:driver_ledger/features/students/data/models/monthly_record.dart';
import 'package:driver_ledger/features/students/domain/backfill_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

MonthlyRecord _record(int month, int year) {
  return MonthlyRecord(
    id: month * 100 + year,
    studentId: 1,
    month: month,
    year: year,
    expectedFee: 5000,
    createdAt: DateTime(year, month, 1),
  );
}

void main() {
  group('calculateProratedFee', () {
    test('join mid-month prorates by remaining days inclusive of join date', () {
      // June 2024 has 30 days. Joining on the 16th leaves 15 remaining days (16..30 inclusive).
      final fee = calculateProratedFee(
        monthlyFee: 3000,
        month: 6,
        year: 2024,
        joinDate: DateTime(2024, 6, 16),
      );

      expect(fee, (3000 / 30) * 15);
    });

    test('join on the 1st returns the full monthly fee', () {
      final fee = calculateProratedFee(
        monthlyFee: 3000,
        month: 6,
        year: 2024,
        joinDate: DateTime(2024, 6, 1),
      );

      expect(fee, 3000);
    });

    test('handles varying days-in-month (February non-leap year)', () {
      // Feb 2023 has 28 days. Joining on the 20th leaves 9 remaining days (20..28 inclusive).
      final fee = calculateProratedFee(
        monthlyFee: 2800,
        month: 2,
        year: 2023,
        joinDate: DateTime(2023, 2, 20),
      );

      expect(fee, (2800 / 28) * 9);
    });

    test('handles varying days-in-month (February leap year)', () {
      // Feb 2024 has 29 days. Joining on the 20th leaves 10 remaining days (20..29 inclusive).
      final fee = calculateProratedFee(
        monthlyFee: 2900,
        month: 2,
        year: 2024,
        joinDate: DateTime(2024, 2, 20),
      );

      expect(fee, (2900 / 29) * 10);
    });

    test('join on the last day of the month returns a single day of fee', () {
      final fee = calculateProratedFee(
        monthlyFee: 3100,
        month: 7,
        year: 2024,
        joinDate: DateTime(2024, 7, 31),
      );

      expect(fee, (3100 / 31) * 1);
    });
  });

  group('calculateMissingMonths', () {
    test('student joining mid-month has a gap through the month before current', () {
      final missing = calculateMissingMonths(
        joinDate: DateTime(2024, 3, 15),
        now: DateTime(2024, 6, 10),
        existingRecords: const [],
      );

      expect(missing, [(month: 3, year: 2024), (month: 4, year: 2024), (month: 5, year: 2024)]);
    });

    test('student joining on the 1st still includes the join month in the gap', () {
      final missing = calculateMissingMonths(
        joinDate: DateTime(2024, 5, 1),
        now: DateTime(2024, 6, 10),
        existingRecords: const [],
      );

      expect(missing, [(month: 5, year: 2024)]);
    });

    test('current month is always excluded, even with no existing records', () {
      final missing = calculateMissingMonths(
        joinDate: DateTime(2024, 6, 1),
        now: DateTime(2024, 6, 10),
        existingRecords: const [],
      );

      expect(missing, isEmpty);
    });

    test('months that already have a record are excluded from the gap', () {
      final missing = calculateMissingMonths(
        joinDate: DateTime(2024, 3, 1),
        now: DateTime(2024, 6, 1),
        existingRecords: [_record(4, 2024)],
      );

      expect(missing, [(month: 3, year: 2024), (month: 5, year: 2024)]);
    });

    test('student with no gap (all months covered) returns empty', () {
      final missing = calculateMissingMonths(
        joinDate: DateTime(2024, 4, 1),
        now: DateTime(2024, 6, 1),
        existingRecords: [_record(4, 2024), _record(5, 2024)],
      );

      expect(missing, isEmpty);
    });

    test('gap spanning a year boundary orders months chronologically', () {
      final missing = calculateMissingMonths(
        joinDate: DateTime(2023, 11, 1),
        now: DateTime(2024, 2, 1),
        existingRecords: const [],
      );

      expect(missing, [
        (month: 11, year: 2023),
        (month: 12, year: 2023),
        (month: 1, year: 2024),
      ]);
    });
  });
}
