import '../../../../core/enums/enums.dart';

class Payment {
  final int? id;
  final int monthlyRecordId;
  final double amount;
  final DateTime paymentDate;
  final PaymentMethod paymentMethod;
  final String? notes;
  final DateTime createdAt;

  const Payment({
    this.id,
    required this.monthlyRecordId,
    required this.amount,
    required this.paymentDate,
    required this.paymentMethod,
    this.notes,
    required this.createdAt,
  });

  Payment copyWith({
    int? id,
    int? monthlyRecordId,
    double? amount,
    DateTime? paymentDate,
    PaymentMethod? paymentMethod,
    String? notes,
    DateTime? createdAt,
  }) {
    return Payment(
      id: id ?? this.id,
      monthlyRecordId: monthlyRecordId ?? this.monthlyRecordId,
      amount: amount ?? this.amount,
      paymentDate: paymentDate ?? this.paymentDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'monthly_record_id': monthlyRecordId,
      'amount': amount,
      'payment_date': paymentDate.toIso8601String(),
      'payment_method': paymentMethod.index,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'] as int?,
      monthlyRecordId: map['monthly_record_id'] as int,
      amount: (map['amount'] as num).toDouble(),
      paymentDate: DateTime.parse(map['payment_date'] as String),
      paymentMethod: PaymentMethod.values[map['payment_method'] as int],
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
