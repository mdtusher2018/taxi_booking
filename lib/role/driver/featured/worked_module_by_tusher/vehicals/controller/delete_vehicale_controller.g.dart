// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_vehicale_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DeleteVehicaleController)
final deleteVehicaleControllerProvider = DeleteVehicaleControllerProvider._();

final class DeleteVehicaleControllerProvider
    extends
        $AsyncNotifierProvider<
          DeleteVehicaleController,
          DeleteVehicleResponse?
        > {
  DeleteVehicaleControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteVehicaleControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteVehicaleControllerHash();

  @$internal
  @override
  DeleteVehicaleController create() => DeleteVehicaleController();
}

String _$deleteVehicaleControllerHash() =>
    r'b14300c282cf89b91e09644f1fed5555526c7379';

abstract class _$DeleteVehicaleController
    extends $AsyncNotifier<DeleteVehicleResponse?> {
  FutureOr<DeleteVehicleResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<DeleteVehicleResponse?>, DeleteVehicleResponse?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<DeleteVehicleResponse?>,
                DeleteVehicleResponse?
              >,
              AsyncValue<DeleteVehicleResponse?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
