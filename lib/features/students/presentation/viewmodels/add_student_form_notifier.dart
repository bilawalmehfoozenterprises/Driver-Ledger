import 'package:faker_dart/faker_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/enums/enums.dart';
import '../../data/models/student.dart';
import '../../data/repositories/student_repository.dart';

part 'add_student_form_notifier.g.dart';

class AddStudentFormState {
  final int? id;
  final String name;
  final String parentName;
  final String parentPhone;
  final String monthlyFee;
  final Shift shift;
  final String pickupLocation;
  final String dropoffLocation;
  final DateTime joinDate;
  final bool isActive;
  final DateTime? createdAt;
  final bool isLoading;
  final bool isSaving;

  const AddStudentFormState({
    this.id,
    this.name = '',
    this.parentName = '',
    this.parentPhone = '',
    this.monthlyFee = '',
    this.shift = Shift.both,
    this.pickupLocation = '',
    this.dropoffLocation = '',
    required this.joinDate,
    this.isActive = true,
    this.createdAt,
    this.isLoading = false,
    this.isSaving = false,
  });

  bool get isEditing => id != null;

  AddStudentFormState copyWith({
    int? id,
    String? name,
    String? parentName,
    String? parentPhone,
    String? monthlyFee,
    Shift? shift,
    String? pickupLocation,
    String? dropoffLocation,
    DateTime? joinDate,
    bool? isActive,
    DateTime? createdAt,
    bool? isLoading,
    bool? isSaving,
  }) {
    return AddStudentFormState(
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
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

@riverpod
class AddStudentFormNotifier extends _$AddStudentFormNotifier {
  @override
  AddStudentFormState build(int? studentId) {
    if (studentId != null) {
      _loadStudent(studentId);
      return AddStudentFormState(joinDate: DateTime.now(), isLoading: true);
    }
    return AddStudentFormState(joinDate: DateTime.now());
  }

  Future<void> _loadStudent(int studentId) async {
    final repository = ref.read(studentRepositoryProvider);
    final student = await repository.getStudent(studentId);
    if (student == null) {
      state = state.copyWith(isLoading: false);
      return;
    }

    state = AddStudentFormState(
      id: student.id,
      name: student.name,
      parentName: student.parentName ?? '',
      parentPhone: student.parentPhone ?? '',
      monthlyFee: student.monthlyFee.toStringAsFixed(0),
      shift: student.shift,
      pickupLocation: student.pickupLocation ?? '',
      dropoffLocation: student.dropoffLocation ?? '',
      joinDate: student.joinDate,
      isActive: student.isActive,
      createdAt: student.createdAt,
      isLoading: false,
    );
  }

  void updateName(String value) => state = state.copyWith(name: value);

  void updateParentName(String value) =>
      state = state.copyWith(parentName: value);

  void updateParentPhone(String value) =>
      state = state.copyWith(parentPhone: value);

  void updateMonthlyFee(String value) =>
      state = state.copyWith(monthlyFee: value);

  void updateShift(Shift value) => state = state.copyWith(shift: value);

  void updatePickupLocation(String value) =>
      state = state.copyWith(pickupLocation: value);

  void updateDropoffLocation(String value) =>
      state = state.copyWith(dropoffLocation: value);

  void updateJoinDate(DateTime value) =>
      state = state.copyWith(joinDate: value);

  void fillMockData() {
    final faker = Faker.instance;
    faker.setLocale(FakerLocaleType.en_IND);

    state = state.copyWith(
      name: faker.name.fullName(),
      parentName: faker.name.fullName(),
      parentPhone: faker.phoneNumber.phoneNumber(format: '03#########'),
      monthlyFee: (3000 + faker.datatype.number(max: 7) * 1000).toString(),
      pickupLocation: faker.address.streetAddress(),
      dropoffLocation: faker.address.city(),
      shift: Shift.values[faker.datatype.number(max: 2)],
      joinDate: DateTime.now(),
    );
  }

  Future<void> save() async {
    state = state.copyWith(isSaving: true);

    final fee = double.tryParse(state.monthlyFee) ?? 0;

    final student = Student(
      id: state.id,
      name: state.name.trim(),
      parentName: state.parentName.trim().isEmpty
          ? null
          : state.parentName.trim(),
      parentPhone: state.parentPhone.trim().isEmpty
          ? null
          : state.parentPhone.trim(),
      monthlyFee: fee,
      shift: state.shift,
      pickupLocation: state.pickupLocation.trim().isEmpty
          ? null
          : state.pickupLocation.trim(),
      dropoffLocation: state.dropoffLocation.trim().isEmpty
          ? null
          : state.dropoffLocation.trim(),
      joinDate: state.joinDate,
      isActive: state.isActive,
      createdAt: state.createdAt ?? DateTime.now(),
    );

    final repository = ref.read(studentRepositoryProvider);
    if (state.isEditing) {
      await repository.updateStudent(student);
    } else {
      await repository.insertStudent(student);
    }

    state = state.copyWith(isSaving: false);
  }
}
