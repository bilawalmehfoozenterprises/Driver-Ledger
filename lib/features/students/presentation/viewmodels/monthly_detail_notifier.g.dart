// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$monthlyDetailNotifierHash() =>
    r'75b35e2ae7666a2ae526bb113be9424e411c1878';

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

abstract class _$MonthlyDetailNotifier
    extends BuildlessAutoDisposeAsyncNotifier<MonthlyRecord?> {
  late final int studentId;
  late final int monthRecordId;

  FutureOr<MonthlyRecord?> build(int studentId, int monthRecordId);
}

/// See also [MonthlyDetailNotifier].
@ProviderFor(MonthlyDetailNotifier)
const monthlyDetailNotifierProvider = MonthlyDetailNotifierFamily();

/// See also [MonthlyDetailNotifier].
class MonthlyDetailNotifierFamily extends Family<AsyncValue<MonthlyRecord?>> {
  /// See also [MonthlyDetailNotifier].
  const MonthlyDetailNotifierFamily();

  /// See also [MonthlyDetailNotifier].
  MonthlyDetailNotifierProvider call(int studentId, int monthRecordId) {
    return MonthlyDetailNotifierProvider(studentId, monthRecordId);
  }

  @override
  MonthlyDetailNotifierProvider getProviderOverride(
    covariant MonthlyDetailNotifierProvider provider,
  ) {
    return call(provider.studentId, provider.monthRecordId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'monthlyDetailNotifierProvider';
}

/// See also [MonthlyDetailNotifier].
class MonthlyDetailNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          MonthlyDetailNotifier,
          MonthlyRecord?
        > {
  /// See also [MonthlyDetailNotifier].
  MonthlyDetailNotifierProvider(int studentId, int monthRecordId)
    : this._internal(
        () => MonthlyDetailNotifier()
          ..studentId = studentId
          ..monthRecordId = monthRecordId,
        from: monthlyDetailNotifierProvider,
        name: r'monthlyDetailNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$monthlyDetailNotifierHash,
        dependencies: MonthlyDetailNotifierFamily._dependencies,
        allTransitiveDependencies:
            MonthlyDetailNotifierFamily._allTransitiveDependencies,
        studentId: studentId,
        monthRecordId: monthRecordId,
      );

  MonthlyDetailNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.studentId,
    required this.monthRecordId,
  }) : super.internal();

  final int studentId;
  final int monthRecordId;

  @override
  FutureOr<MonthlyRecord?> runNotifierBuild(
    covariant MonthlyDetailNotifier notifier,
  ) {
    return notifier.build(studentId, monthRecordId);
  }

  @override
  Override overrideWith(MonthlyDetailNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: MonthlyDetailNotifierProvider._internal(
        () => create()
          ..studentId = studentId
          ..monthRecordId = monthRecordId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        studentId: studentId,
        monthRecordId: monthRecordId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<MonthlyDetailNotifier, MonthlyRecord?>
  createElement() {
    return _MonthlyDetailNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyDetailNotifierProvider &&
        other.studentId == studentId &&
        other.monthRecordId == monthRecordId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, studentId.hashCode);
    hash = _SystemHash.combine(hash, monthRecordId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MonthlyDetailNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<MonthlyRecord?> {
  /// The parameter `studentId` of this provider.
  int get studentId;

  /// The parameter `monthRecordId` of this provider.
  int get monthRecordId;
}

class _MonthlyDetailNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          MonthlyDetailNotifier,
          MonthlyRecord?
        >
    with MonthlyDetailNotifierRef {
  _MonthlyDetailNotifierProviderElement(super.provider);

  @override
  int get studentId => (origin as MonthlyDetailNotifierProvider).studentId;
  @override
  int get monthRecordId =>
      (origin as MonthlyDetailNotifierProvider).monthRecordId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
