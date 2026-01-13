// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicale_details_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VehicaleDetailsController)
final vehicaleDetailsControllerProvider = VehicaleDetailsControllerProvider._();

final class VehicaleDetailsControllerProvider
    extends
        $AsyncNotifierProvider<VehicaleDetailsController, VehicleResponse?> {
  VehicaleDetailsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vehicaleDetailsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vehicaleDetailsControllerHash();

  @$internal
  @override
  VehicaleDetailsController create() => VehicaleDetailsController();
}

String _$vehicaleDetailsControllerHash() =>
    r'07351b2a752eb01d3494d87be95679bd816ee510';

abstract class _$VehicaleDetailsController
    extends $AsyncNotifier<VehicleResponse?> {
  FutureOr<VehicleResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<VehicleResponse?>, VehicleResponse?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<VehicleResponse?>, VehicleResponse?>,
              AsyncValue<VehicleResponse?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
