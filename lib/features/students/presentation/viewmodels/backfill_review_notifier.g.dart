// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backfill_review_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$backfillReviewNotifierHash() =>
    r'dfbe3ca2ba60a1aa441e8b123b16acee4f0af290';

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

abstract class _$BackfillReviewNotifier
    extends BuildlessAutoDisposeAsyncNotifier<BackfillReviewState> {
  late final int studentId;

  FutureOr<BackfillReviewState> build(int studentId);
}

/// See also [BackfillReviewNotifier].
@ProviderFor(BackfillReviewNotifier)
const backfillReviewNotifierProvider = BackfillReviewNotifierFamily();

/// See also [BackfillReviewNotifier].
class BackfillReviewNotifierFamily
    extends Family<AsyncValue<BackfillReviewState>> {
  /// See also [BackfillReviewNotifier].
  const BackfillReviewNotifierFamily();

  /// See also [BackfillReviewNotifier].
  BackfillReviewNotifierProvider call(int studentId) {
    return BackfillReviewNotifierProvider(studentId);
  }

  @override
  BackfillReviewNotifierProvider getProviderOverride(
    covariant BackfillReviewNotifierProvider provider,
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
  String? get name => r'backfillReviewNotifierProvider';
}

/// See also [BackfillReviewNotifier].
class BackfillReviewNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          BackfillReviewNotifier,
          BackfillReviewState
        > {
  /// See also [BackfillReviewNotifier].
  BackfillReviewNotifierProvider(int studentId)
    : this._internal(
        () => BackfillReviewNotifier()..studentId = studentId,
        from: backfillReviewNotifierProvider,
        name: r'backfillReviewNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$backfillReviewNotifierHash,
        dependencies: BackfillReviewNotifierFamily._dependencies,
        allTransitiveDependencies:
            BackfillReviewNotifierFamily._allTransitiveDependencies,
        studentId: studentId,
      );

  BackfillReviewNotifierProvider._internal(
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
  FutureOr<BackfillReviewState> runNotifierBuild(
    covariant BackfillReviewNotifier notifier,
  ) {
    return notifier.build(studentId);
  }

  @override
  Override overrideWith(BackfillReviewNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: BackfillReviewNotifierProvider._internal(
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
    BackfillReviewNotifier,
    BackfillReviewState
  >
  createElement() {
    return _BackfillReviewNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BackfillReviewNotifierProvider &&
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
mixin BackfillReviewNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<BackfillReviewState> {
  /// The parameter `studentId` of this provider.
  int get studentId;
}

class _BackfillReviewNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          BackfillReviewNotifier,
          BackfillReviewState
        >
    with BackfillReviewNotifierRef {
  _BackfillReviewNotifierProviderElement(super.provider);

  @override
  int get studentId => (origin as BackfillReviewNotifierProvider).studentId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
