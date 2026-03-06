// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_ride_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeRideController)
final homeRideControllerProvider = HomeRideControllerProvider._();

final class HomeRideControllerProvider
    extends $NotifierProvider<HomeRideController, HomeRideState> {
  HomeRideControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeRideControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeRideControllerHash();

  @$internal
  @override
  HomeRideController create() => HomeRideController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeRideState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeRideState>(value),
    );
  }
}

String _$homeRideControllerHash() =>
    r'2b91f592e47bea28721f8d4b5c92f1806a0d8b78';

abstract class _$HomeRideController extends $Notifier<HomeRideState> {
  HomeRideState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<HomeRideState, HomeRideState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HomeRideState, HomeRideState>,
              HomeRideState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
