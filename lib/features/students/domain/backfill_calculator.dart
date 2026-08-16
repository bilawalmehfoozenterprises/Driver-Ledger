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
