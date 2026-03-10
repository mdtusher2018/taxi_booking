// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehical_category_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VehicalCategoryController)
final vehicalCategoryControllerProvider = VehicalCategoryControllerProvider._();

final class VehicalCategoryControllerProvider
    extends
        $AsyncNotifierProvider<VehicalCategoryController, List<PricingModel>?> {
  VehicalCategoryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vehicalCategoryControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vehicalCategoryControllerHash();

  @$internal
  @override
  VehicalCategoryController create() => VehicalCategoryController();
}

String _$vehicalCategoryControllerHash() =>
    r'cc16a4be1a8471c2ac33b90376f70428246d0bff';

abstract class _$VehicalCategoryController
    extends $AsyncNotifier<List<PricingModel>?> {
  FutureOr<List<PricingModel>?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<PricingModel>?>, List<PricingModel>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<PricingModel>?>, List<PricingModel>?>,
              AsyncValue<List<PricingModel>?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
