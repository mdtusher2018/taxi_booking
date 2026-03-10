import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/role/driver/driver_di/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxi_booking/role/driver/featured/vehicals/vehical_repository.dart';
import 'package:taxi_booking/role/user/featured/booking_map/model/pricing_model.dart';

part 'vehical_category_controller.g.dart';

@riverpod
class VehicalCategoryController extends _$VehicalCategoryController {
  late VehicalRepository repo;

  @override
  FutureOr<List<PricingModel>?> build() {
    repo = ref.watch(vehicalRepositoryProvider);
    return null;
  }

  Future<void> fetchPricingData() async {
    state = const AsyncLoading();

    final response = await repo.getVehicaleCategory();
    if (!ref.mounted) return;
    if (response is FailureResult) {
      final error = (response as FailureResult).error as Failure;
      state = AsyncError(
        error.message,
        error.stackTrace ?? StackTrace.fromString("No StackTrace Found"),
      );
    } else if (response is Success) {
      state = AsyncData((response as Success).data as List<PricingModel>);
    }
  }
}
