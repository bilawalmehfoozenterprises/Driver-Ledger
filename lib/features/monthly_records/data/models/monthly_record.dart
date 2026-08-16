class MonthlyRecord {
  final int? id;
  final int studentId;
  final int month;
  final int year;
  final double expectedFee;
  final double totalPaid;
  final bool isVacation;
  final int? vacationDays;
  final double? deductionAmount;
  final String? notes;
  final DateTime createdAt;

  const MonthlyRecord({
    this.id,
    required this.studentId,
    required this.month,
    required this.year,
    required this.expectedFee,
    this.totalPaid = 0,
    this.isVacation = false,
    this.vacationDays,
    this.deductionAmount,
    this.notes,
    required this.createdAt,
  });

  double get amountDue => expectedFee - (deductionAmount ?? 0);

  double get balance => amountDue - totalPaid;

  bool get isFullyPaid => balance <= 0;

  MonthlyRecord copyWith({
    int? id,
    int? studentId,
    int? month,
    int? year,
    double? expectedFee,
    double? totalPaid,
    bool? isVacation,
    int? vacationDays,
    double? deductionAmount,
    String? notes,
    DateTime? createdAt,
  }) {
    return MonthlyRecord(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      month: month ?? this.month,
      year: year ?? this.year,
      expectedFee: expectedFee ?? this.expectedFee,
      totalPaid: totalPaid ?? this.totalPaid,
      isVacation: isVacation ?? this.isVacation,
      vacationDays: vacationDays ?? this.vacationDays,
      deductionAmount: deductionAmount ?? this.deductionAmount,
      notes: notes ?? this.notes,
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
      'total_paid': totalPaid,
      'is_vacation': isVacation ? 1 : 0,
      'vacation_days': vacationDays,
      'deduction_amount': deductionAmount,
      'notes': notes,
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
      totalPaid: (map['total_paid'] as num).toDouble(),
      isVacation: (map['is_vacation'] as int) == 1,
      vacationDays: map['vacation_days'] as int?,
      deductionAmount: (map['deduction_amount'] as num?)?.toDouble(),
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
