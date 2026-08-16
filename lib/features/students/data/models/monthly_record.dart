class MonthlyRecord {
  final int? id;
  final int studentId;
  final int month;
  final int year;
  final double expectedFee;
  final int vacationDays;
  final double deductionAmount;
  final double totalPaid;
  final DateTime createdAt;

  const MonthlyRecord({
    this.id,
    required this.studentId,
    required this.month,
    required this.year,
    required this.expectedFee,
    this.vacationDays = 0,
    this.deductionAmount = 0,
    this.totalPaid = 0,
    required this.createdAt,
  });

  double get amountDue => expectedFee - deductionAmount;

  double get balance => amountDue - totalPaid;

  bool get isFullyPaid => balance <= 0;

  String get status {
    if (isFullyPaid) return 'Paid';
    if (totalPaid > 0) return 'Partial';
    return 'Unpaid';
  }

  MonthlyRecord copyWith({
    int? id,
    int? studentId,
    int? month,
    int? year,
    double? expectedFee,
    int? vacationDays,
    double? deductionAmount,
    double? totalPaid,
    DateTime? createdAt,
  }) {
    return MonthlyRecord(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      month: month ?? this.month,
      year: year ?? this.year,
      expectedFee: expectedFee ?? this.expectedFee,
      vacationDays: vacationDays ?? this.vacationDays,
      deductionAmount: deductionAmount ?? this.deductionAmount,
      totalPaid: totalPaid ?? this.totalPaid,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'student_id': studentId,
      'month': month,
      'year': year,
      'expected_fee': expectedFee,
      'vacation_days': vacationDays,
      'deduction_amount': deductionAmount,
      'total_paid': totalPaid,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory MonthlyRecord.fromMap(Map<String, dynamic> map) {
    return MonthlyRecord(
      id: map['id'] as int?,
      studentId: map['student_id'] as int,
      month: map['month'] as int,
      year: map['year'] as int,
      expectedFee: (map['expected_fee'] as num).toDouble(),
      vacationDays: map['vacation_days'] as int? ?? 0,
      deductionAmount: (map['deduction_amount'] as num?)?.toDouble() ?? 0,
      totalPaid: (map['total_paid'] as num?)?.toDouble() ?? 0,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
