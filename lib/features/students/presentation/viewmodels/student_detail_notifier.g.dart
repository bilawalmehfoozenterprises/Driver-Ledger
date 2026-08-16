// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$studentDetailNotifierHash() =>
    r'23d54672865f95c885a87141a3027d5bfd05f118';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$StudentDetailNotifier
    extends BuildlessAutoDisposeAsyncNotifier<StudentDetailState> {
  late final int studentId;

  FutureOr<StudentDetailState> build(int studentId);
}

/// See also [StudentDetailNotifier].
@ProviderFor(StudentDetailNotifier)
const studentDetailNotifierProvider = StudentDetailNotifierFamily();

/// See also [StudentDetailNotifier].
class StudentDetailNotifierFamily
    extends Family<AsyncValue<StudentDetailState>> {
  /// See also [StudentDetailNotifier].
  const StudentDetailNotifierFamily();

  /// See also [StudentDetailNotifier].
  StudentDetailNotifierProvider call(int studentId) {
    return StudentDetailNotifierProvider(studentId);
  }

  @override
  StudentDetailNotifierProvider getProviderOverride(
    covariant StudentDetailNotifierProvider provider,
  ) {
    return call(provider.studentId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'studentDetailNotifierProvider';
}

/// See also [StudentDetailNotifier].
class StudentDetailNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          StudentDetailNotifier,
          StudentDetailState
        > {
  /// See also [StudentDetailNotifier].
  StudentDetailNotifierProvider(int studentId)
    : this._internal(
        () => StudentDetailNotifier()..studentId = studentId,
        from: studentDetailNotifierProvider,
        name: r'studentDetailNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$studentDetailNotifierHash,
        dependencies: StudentDetailNotifierFamily._dependencies,
        allTransitiveDependencies:
            StudentDetailNotifierFamily._allTransitiveDependencies,
        studentId: studentId,
      );

  StudentDetailNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.studentId,
  }) : super.internal();

  final int studentId;

  @override
  FutureOr<StudentDetailState> runNotifierBuild(
    covariant StudentDetailNotifier notifier,
  ) {
    return notifier.build(studentId);
  }

  @override
  Override overrideWith(StudentDetailNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: StudentDetailNotifierProvider._internal(
        () => create()..studentId = studentId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        studentId: studentId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    StudentDetailNotifier,
    StudentDetailState
  >
  createElement() {
    return _StudentDetailNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StudentDetailNotifierProvider &&
        other.studentId == studentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, studentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StudentDetailNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<StudentDetailState> {
  /// The parameter `studentId` of this provider.
  int get studentId;
}

class _StudentDetailNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          StudentDetailNotifier,
          StudentDetailState
        >
    with StudentDetailNotifierRef {
  _StudentDetailNotifierProviderElement(super.provider);

  @override
  int get studentId => (origin as StudentDetailNotifierProvider).studentId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
