import '../../../../core/enums/enums.dart';

class Student {
  final int? id;
  final String name;
  final String parentName;
  final String parentPhone;
  final double currentFee;
  final Shift shift;
  final bool isActive;
  final DateTime createdAt;

  const Student({
    this.id,
    required this.name,
    required this.parentName,
    required this.parentPhone,
    required this.currentFee,
    required this.shift,
    this.isActive = true,
    required this.createdAt,
  });

  Student copyWith({
    int? id,
    String? name,
    String? parentName,
    String? parentPhone,
    double? currentFee,
    Shift? shift,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      parentName: parentName ?? this.parentName,
      parentPhone: parentPhone ?? this.parentPhone,
      currentFee: currentFee ?? this.currentFee,
      shift: shift ?? this.shift,
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
      'current_fee': currentFee,
      'shift': shift.index,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as int?,
      name: map['name'] as String,
      parentName: map['parent_name'] as String,
      parentPhone: map['parent_phone'] as String,
      currentFee: (map['current_fee'] as num).toDouble(),
      shift: Shift.values[map['shift'] as int],
      isActive: (map['is_active'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
