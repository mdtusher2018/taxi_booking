import 'package:taxi_booking/core/base/failure.dart';
import 'package:taxi_booking/core/base/result.dart';
import 'package:taxi_booking/resource/utilitis/custom_toast.dart';
import 'package:taxi_booking/role/driver/driver_di/repository.dart';
import 'package:taxi_booking/core/pagination/paginated_async_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/driver/drivers_repository.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/driver/models/my_drivers_response.dart';

final myDriversControllerProvider =
    AsyncNotifierProvider<MyDriversController, PaginationState<AssignedDriver>>(
      MyDriversController.new,
    );

class MyDriversController extends PaginatedAsyncNotifier<AssignedDriver> {
  late DriversRepository repo;
  @override
  Future<PaginationState<AssignedDriver>> build() async {
    repo = ref.watch(driversRepositoryProvider);
    return PaginationState<AssignedDriver>();
  }

  @override
  Future<Result<List<AssignedDriver>, Failure>> fetchPage(int page) async {
    final result = await repo.fetchMyDrivers(page: page);
    if (result is FailureResult) {
      final error = (result as FailureResult).error as Failure;
      return FailureResult(error);
    }
    return Success(
      ((result as Success).data as AssignedDriversResponse).data.result,
    );
  }

  Future<void> removeDrver({
    required String driverId,
    required String vehicaleId,
  }) async {
    final result = await repo.removeDrver(
      driverId: driverId,
      vehicalId: vehicaleId,
    );
    if (result is Success) {
      CustomToast.showToast(
        message: "Driver removed sucessfully",
        isError: true,
      );
      refresh();
    }
    if (result is FailureResult) {
      final error = (result as FailureResult).error as Failure;
      CustomToast.showToast(message: error.message, isError: true);
    }
  }
}
