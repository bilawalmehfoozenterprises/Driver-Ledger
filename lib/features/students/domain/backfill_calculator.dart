import '../data/models/monthly_record.dart';

typedef MissingMonth = ({int month, int year});

double calculateProratedFee({
  required double monthlyFee,
  required int month,
  required int year,
  required DateTime joinDate,
}) {
  final daysInMonth = DateTime(year, month + 1, 0).day;
  final remainingDays = daysInMonth - joinDate.day + 1;
  final dailyRate = monthlyFee / daysInMonth;
  return dailyRate * remainingDays;
}

List<MissingMonth> calculateMissingMonths({
  required DateTime joinDate,
  required DateTime now,
  required List<MonthlyRecord> existingRecords,
}) {
  final existing = existingRecords.map((r) => (month: r.month, year: r.year)).toSet();

  final missing = <MissingMonth>[];
  var month = joinDate.month;
  var year = joinDate.year;

  while (year < now.year || (year == now.year && month < now.month)) {
    final current = (month: month, year: year);
    if (!existing.contains(current)) missing.add(current);

    if (month == 12) {
      month = 1;
      year++;
    } else {
      month++;
    }
  }

  return missing;
}

typedef LaterJoinDateImpact = ({
  List<MonthlyRecord> toDelete,
  MonthlyRecord? toReprorate,
});

/// Splits a Student's existing records by the impact of moving `joinDate`
/// to a later date: records strictly before the new joinDate's month must
/// be deleted, while a record that falls in the same month as the new
/// joinDate must be reprorated instead of deleted.
LaterJoinDateImpact recordsAffectedByLaterJoinDate({
  required DateTime newJoinDate,
  required List<MonthlyRecord> existingRecords,
}) {
  final newJoinKey = newJoinDate.year * 12 + newJoinDate.month;

  final toDelete = <MonthlyRecord>[];
  MonthlyRecord? toReprorate;

  for (final record in existingRecords) {
    final recordKey = record.year * 12 + record.month;
    if (recordKey < newJoinKey) {
      toDelete.add(record);
    } else if (recordKey == newJoinKey) {
      toReprorate = record;
    }
  }

  toDelete.sort((a, b) => (a.year * 12 + a.month).compareTo(b.year * 12 + b.month));

  return (toDelete: toDelete, toReprorate: toReprorate);
}
