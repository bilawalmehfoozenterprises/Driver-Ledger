import '../../../../core/enums/enums.dart';

class Student {
  final int? id;
  final String name;
  final String? parentName;
  final String? parentPhone;
  final double monthlyFee;
  final Shift shift;
  final String? pickupLocation;
  final String? dropoffLocation;
  final DateTime joinDate;
  final bool isActive;
  final DateTime createdAt;

  const Student({
    this.id,
    required this.name,
    this.parentName,
    this.parentPhone,
    required this.monthlyFee,
    required this.shift,
    this.pickupLocation,
    this.dropoffLocation,
    required this.joinDate,
    this.isActive = true,
    required this.createdAt,
  });

  Student copyWith({
    int? id,
    String? name,
    String? parentName,
    String? parentPhone,
    double? monthlyFee,
    Shift? shift,
    String? pickupLocation,
    String? dropoffLocation,
    DateTime? joinDate,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      parentName: parentName ?? this.parentName,
      parentPhone: parentPhone ?? this.parentPhone,
      monthlyFee: monthlyFee ?? this.monthlyFee,
      shift: shift ?? this.shift,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      joinDate: joinDate ?? this.joinDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'parent_name': parentName,
      'parent_phone': parentPhone,
      'monthly_fee': monthlyFee,
      'shift': shift.index,
      'pickup_location': pickupLocation,
      'dropoff_location': dropoffLocation,
      'join_date': joinDate.toIso8601String(),
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as int?,
      name: map['name'] as String,
      parentName: map['parent_name'] as String?,
      parentPhone: map['parent_phone'] as String?,
      monthlyFee: (map['monthly_fee'] as num).toDouble(),
      shift: Shift.values[map['shift'] as int],
      pickupLocation: map['pickup_location'] as String?,
      dropoffLocation: map['dropoff_location'] as String?,
      joinDate: DateTime.parse(map['join_date'] as String),
      isActive: (map['is_active'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
