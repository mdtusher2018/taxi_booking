import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/role/driver/driver_di/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/model/delete_vehical_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/vehical_repository.dart';

part 'delete_vehicale_controller.g.dart';

@riverpod
class DeleteVehicaleController extends _$DeleteVehicaleController {
  late VehicalRepository repo;

  @override
  FutureOr<DeleteVehicleResponse?> build() async {
    repo = ref.watch(vehicalRepositoryProvider);
    return null;
  }

  Future<void> deleteVehicale({required String vehicaleId}) async {
    final result = await repo.deleteVehical(vehicalId: vehicaleId);
    if (result is FailureResult) {
      final error = (result as FailureResult).error as Failure;
      state = AsyncError(
        error.message,
        error.stackTrace ?? StackTrace.fromString("No StackTrace Found"),
      );
    }

    state = AsyncData((result as Success).data as DeleteVehicleResponse);
  }
}
