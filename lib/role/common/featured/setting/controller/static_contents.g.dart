// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'static_contents.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StaticContentsController)
final staticContentsControllerProvider = StaticContentsControllerProvider._();

final class StaticContentsControllerProvider
    extends $AsyncNotifierProvider<StaticContentsController, dynamic> {
  StaticContentsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'staticContentsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$staticContentsControllerHash();

  @$internal
  @override
  StaticContentsController create() => StaticContentsController();
}

String _$staticContentsControllerHash() =>
    r'e3177e5bfa35383b52a39aebb8fe03c208280422';

abstract class _$StaticContentsController extends $AsyncNotifier<dynamic> {
  FutureOr<dynamic> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<dynamic>, dynamic>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<dynamic>, dynamic>,
              AsyncValue<dynamic>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
