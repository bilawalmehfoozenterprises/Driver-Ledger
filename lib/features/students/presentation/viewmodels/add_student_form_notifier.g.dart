// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_student_form_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$addStudentFormNotifierHash() =>
    r'81f4c7874d24aba363766c278e28bda4a4f6527d';

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

abstract class _$AddStudentFormNotifier
    extends BuildlessAutoDisposeNotifier<AddStudentFormState> {
  late final int? studentId;

  AddStudentFormState build(int? studentId);
}

/// See also [AddStudentFormNotifier].
@ProviderFor(AddStudentFormNotifier)
const addStudentFormNotifierProvider = AddStudentFormNotifierFamily();

/// See also [AddStudentFormNotifier].
class AddStudentFormNotifierFamily extends Family<AddStudentFormState> {
  /// See also [AddStudentFormNotifier].
  const AddStudentFormNotifierFamily();

  /// See also [AddStudentFormNotifier].
  AddStudentFormNotifierProvider call(int? studentId) {
    return AddStudentFormNotifierProvider(studentId);
  }

  @override
  AddStudentFormNotifierProvider getProviderOverride(
    covariant AddStudentFormNotifierProvider provider,
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
  String? get name => r'addStudentFormNotifierProvider';
}

/// See also [AddStudentFormNotifier].
class AddStudentFormNotifierProvider
    extends
        AutoDisposeNotifierProviderImpl<
          AddStudentFormNotifier,
          AddStudentFormState
        > {
  /// See also [AddStudentFormNotifier].
  AddStudentFormNotifierProvider(int? studentId)
    : this._internal(
        () => AddStudentFormNotifier()..studentId = studentId,
        from: addStudentFormNotifierProvider,
        name: r'addStudentFormNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$addStudentFormNotifierHash,
        dependencies: AddStudentFormNotifierFamily._dependencies,
        allTransitiveDependencies:
            AddStudentFormNotifierFamily._allTransitiveDependencies,
        studentId: studentId,
      );

  AddStudentFormNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.studentId,
  }) : super.internal();

  final int? studentId;

  @override
  AddStudentFormState runNotifierBuild(
    covariant AddStudentFormNotifier notifier,
  ) {
    return notifier.build(studentId);
  }

  @override
  Override overrideWith(AddStudentFormNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: AddStudentFormNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<
    AddStudentFormNotifier,
    AddStudentFormState
  >
  createElement() {
    return _AddStudentFormNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AddStudentFormNotifierProvider &&
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
mixin AddStudentFormNotifierRef
    on AutoDisposeNotifierProviderRef<AddStudentFormState> {
  /// The parameter `studentId` of this provider.
  int? get studentId;
}

class _AddStudentFormNotifierProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          AddStudentFormNotifier,
          AddStudentFormState
        >
    with AddStudentFormNotifierRef {
  _AddStudentFormNotifierProviderElement(super.provider);

  @override
  int? get studentId => (origin as AddStudentFormNotifierProvider).studentId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
