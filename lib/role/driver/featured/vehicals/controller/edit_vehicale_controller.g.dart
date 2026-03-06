// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_vehicale_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EditVehicalController)
final editVehicalControllerProvider = EditVehicalControllerProvider._();

final class EditVehicalControllerProvider
    extends
        $AsyncNotifierProvider<EditVehicalController, EditVehicleResponse?> {
  EditVehicalControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editVehicalControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editVehicalControllerHash();

  @$internal
  @override
  EditVehicalController create() => EditVehicalController();
}

String _$editVehicalControllerHash() =>
    r'1e13c47a63d6e8d445d8dae971200300a9e3602e';

abstract class _$EditVehicalController
    extends $AsyncNotifier<EditVehicleResponse?> {
  FutureOr<EditVehicleResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<EditVehicleResponse?>, EditVehicleResponse?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<EditVehicleResponse?>,
                EditVehicleResponse?
              >,
              AsyncValue<EditVehicleResponse?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
