import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/role/driver/driver_di/repository.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/model/vehicale_details_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/vehical_repository.dart';

part 'vehicale_details_controller.g.dart';

@riverpod
class VehicaleDetailsController extends _$VehicaleDetailsController {
  late VehicalRepository repository;

  @override
  FutureOr<VehicleResponse?> build() async {
    repository = ref.watch(vehicalRepositoryProvider);
    return null;
  }

  Future<void> vehicaleDetails({required String vehicaleId}) async {
    state = AsyncLoading();
    final result = await repository.vehicalDetails(vehicalId: vehicaleId);

    if (result is FailureResult) {
      final error = (result as FailureResult).error as Failure;
      state = AsyncError(
        error.message,
        error.stackTrace ?? StackTrace.fromString("No StackTrace Found"),
      );
    } else if (result is Success) {
      state = AsyncData((result as Success).data as VehicleResponse);
    }
  }
}
