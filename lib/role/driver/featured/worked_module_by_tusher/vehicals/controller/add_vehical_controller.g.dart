// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_vehical_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AddVehicalController)
final addVehicalControllerProvider = AddVehicalControllerProvider._();

final class AddVehicalControllerProvider
    extends $AsyncNotifierProvider<AddVehicalController, AddVehicleResponse?> {
  AddVehicalControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addVehicalControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addVehicalControllerHash();

  @$internal
  @override
  AddVehicalController create() => AddVehicalController();
}

String _$addVehicalControllerHash() =>
    r'4745b468241bd42d93ae4cfb26b2eb244a258bf8';

abstract class _$AddVehicalController
    extends $AsyncNotifier<AddVehicleResponse?> {
  FutureOr<AddVehicleResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<AddVehicleResponse?>, AddVehicleResponse?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AddVehicleResponse?>, AddVehicleResponse?>,
              AsyncValue<AddVehicleResponse?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
